//
//  URLSessionHTTPClient.swift
//  NewsFeed
//
//  Created by mustafa salah eldin on 9/25/21.
//

import Foundation

public class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
        
    }
    
    public func get<T: Decodable>(from url: URL, completion: @escaping (HTTPClient.HTTPResult<T>) -> Void) {
        session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }  else if let data = data {
                let responseObject:T? = try? JSONDecoder().decode(T.self, from: data)
                if let unwrappedResponseObject = responseObject {
                    completion(.success(unwrappedResponseObject))
                }
            }
        }.resume()
    }
}


