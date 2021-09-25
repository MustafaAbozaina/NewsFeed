//
//  URLProtocolStub.swift
//  NewsFeedTests
//
//  Created by mustafa salah eldin on 9/25/21.
//

import Foundation

public class URLProtocolStub: URLProtocol {
    private static var stub: Stub?
    private static var requestObserver: ((URLRequest) -> Void)?

    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
    }
    
    static func stub(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil ) {
        stub = Stub(data: data, response: response, error: error)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) {
        requestObserver = observer
    }
    
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        stub = nil
        requestObserver = nil
    }
    
    public override class func canInit(with request: URLRequest) -> Bool {
        requestObserver?(request)
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        
        if let error = URLProtocolStub.stub?.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else if let data = URLProtocolStub.stub?.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    public override func stopLoading() {}
}
