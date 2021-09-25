//
//  URLSessionHTTPClientTests.swift
//  NewsFeedTests
//
//  Created by mustafa salah eldin on 9/24/21.
//

import XCTest
import NewsFeed

class URLSessionHTTPClientTests: XCTestCase {
    
    override class func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }
    
    let anyUrl = URL(string: "http://any-url.com")!
    
    func test_getFromURL_failsOnRequestError() {
        let url = anyUrl
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: URLResponse(), error: error)
                
        let exp = expectation(description: "Wait for completion")
        
        createSUT().get(from: url) { (result: HTTPClient.HTTPResult<NoType>) in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError.code, error.code)
                XCTAssertEqual(receivedError.domain, receivedError.domain)
            default:
                XCTFail("Expected failure with error \(error), got \(result) instead")
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_successOnRequestSuccess() {
        let url = anyUrl
        let jsonData = try! JSONSerialization.data(withJSONObject: ["id" : "1"])
        URLProtocolStub.stub(data: jsonData)
        
        
        let exp = expectation(description: "Wait for completion")
        URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url) // making sure the sent Url is the same as the used one
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        createSUT().get(from: url) { (result: HTTPClientResult<NoType>) in
            switch result {
            case .success(_):
                break
            default:
                XCTFail("Expected success , got \(result) instead")
            }
            
        }
        
        wait(for: [exp], timeout: 1)
    }
    
    // MARK: - Helpers
    
    private func createSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
}


private class NoType: Decodable {
    var id: String?
}
