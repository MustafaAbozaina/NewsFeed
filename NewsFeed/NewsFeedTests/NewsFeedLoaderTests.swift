//
//  NewsFeedLoader.swift
//  NewsFeedTests
//
//  Created by mustafa salah eldin on 9/25/21.
//

import XCTest
import NewsFeed

class NewsFeedRoot: Decodable {
    let status: String?
    let totalResults: Int?
    let articles: [Article]?
}

class Article: Decodable {
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

class ArticleSource: Decodable {
    let id: Int?
    let name: String?
}

class RemoteNewsFeedLoader {

    func load(url: URL, client: HTTPClient, completion: @escaping (NewsFeedRoot?,Error?) -> Void) {
        client.get(from: url) { (root: HTTPClientResult<NewsFeedRoot>) in
            switch root {
            case .success(let a):
                print(a)
                completion(a,nil)
                break
            case .failure(let error):
                completion(nil,error)
                break
            }
        }
    }
}

class RemoteNewsFeedLoaderTests: XCTestCase {
    let anyUrl = URL(string: "www.temp.com")!
    override class func tearDown() {
        super.tearDown()
        URLProtocolStub.removeStub() 
    }
    
    func test_init_doesNotRequestDataFromURL() {
        
        let _ = createHTTPClient()
        _ = RemoteNewsFeedLoader()
        
        URLProtocolStub.observeRequests { request in
            XCTFail()
        }
    }
    
    func test_load_requestFiredCorreclty() {
        let exp = expectation(description: "should observe request")
        let client = createHTTPClient()
        let sut = RemoteNewsFeedLoader()
        let url = anyUrl
        sut.load(url: url , client: client) { newsRoot, error in
            
        }
        URLProtocolStub.observeRequests { request in
            exp.fulfill()
            
        }
        wait(for: [exp], timeout: 1)
    }
    
    func test_load_successfullyRespondeNewsFeedRoot() {
        
        let client = createHTTPClient()
        let jsonData = try! JSONSerialization.data(withJSONObject: ["status": "ok",
                                                                    "totalResults": 2957])
        let exp = self.expectation(description: "should retrive NewsFeedRoot which contais status which equall ok ")
        URLProtocolStub.stub(data: jsonData, response: nil, error: nil)
        
        let sut = RemoteNewsFeedLoader()
        sut.load(url: URL(string: "www.anyURl.com")!, client: client) { newsRoot, error in
            if newsRoot?.status == "ok" {
                exp.fulfill()
            }
        }
        
        self.wait(for: [exp], timeout: 1)
    }
    func test_load_successfullyRespondeAllJsonDataNewsFeed() {
        
        let client = createHTTPClient()
        let jsonData = try! JSONSerialization.data(withJSONObject: NewsFeedMocking.newsRootMockedJson)
        
        let exp = self.expectation(description: "should retrive NewsFeedRoot which contais status which equall ok")
        URLProtocolStub.stub(data: jsonData, response: URLResponse(), error: nil)
        
        let sut = RemoteNewsFeedLoader()
        sut.load(url: URL(string: "www.anyURl.com")!, client: client) { newsRoot, error in
            if let _ =  newsRoot?.articles {
                exp.fulfill()
            }
        }
        
        self.wait(for: [exp], timeout: 2)
    }
    
    func test_load_failsOnRequestError() {
        let client = createHTTPClient()
        let exp = self.expectation(description: "should fail on error")
        URLProtocolStub.stub(data: nil, response: nil, error: NSError(domain: "Error", code: 1))
        
        let sut = RemoteNewsFeedLoader()
        sut.load(url: anyUrl, client: client) { news, error in
            if let _ = error {
                exp.fulfill()
            }
        }
        
        self.wait(for: [exp], timeout: 1)
    }
    // MARK: Helpers
    
    private func createHTTPClient(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let httpClient = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(httpClient, file: file, line: line)
        return httpClient
    }
    
    private func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }    
}

