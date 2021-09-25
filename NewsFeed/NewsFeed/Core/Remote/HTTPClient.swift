//
//  HTTPClient.swift
//  NewsFeed
//
//  Created by mustafa salah eldin on 9/25/21.
//

import Foundation

public protocol HTTPClient {
    func get<T: Decodable>(from url: URL, completion: @escaping (HTTPClientResult<T>) -> Void)
    typealias HTTPResult = HTTPClientResult
}

public enum HTTPClientResult<T: Decodable> {
    case failure(Error)
    case success(T)
}
