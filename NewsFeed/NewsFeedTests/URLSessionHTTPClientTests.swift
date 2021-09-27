//
//  URLSessionHTTPClientTests.swift
//  NewsFeedTests
//
//  Created by mustafa salah eldin on 9/24/21.
//

import XCTest
import NewsFeed

class URLSessionHTTPClientTests: XCTestCase {
    let anyUrl = URL(string: "http://any-url.com")!
    
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub()
    }
    
    func test_getFromURL_failsOnRequestError() {
        let url = anyUrl
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: URLResponse(), error: error)
        let exp = expectation(description: "Should fail because we stubbed with error")
        createSUT().get(from: url) { (result: HTTPClient.HTTPResult<NoType>) in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertNotNil(receivedError)
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
        URLProtocolStub.stub(data: jsonData,response: nil, error: nil)
        let exp = expectation(description: "should succeed requesting a url  ")
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
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        let sut = URLSessionHTTPClient(session: session)
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
