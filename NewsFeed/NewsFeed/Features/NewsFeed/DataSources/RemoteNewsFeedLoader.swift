//
//  RemoteNewsFeedLoader.swift
//  NewsFeed
//
//  Created by mustafa salah eldin on 9/28/21.
//

import Foundation


public class RemoteNewsFeedLoader: NewsFeedLoader {
    var url: URL
    var client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    public func load(completion: @escaping (NewsFeedRoot?,Error?) -> Void) {
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
