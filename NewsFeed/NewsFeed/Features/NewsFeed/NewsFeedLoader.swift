//
//  NewsFeedLoader.swift
//  NewsFeed
//
//  Created by mustafa salah eldin on 9/28/21.
//

import Foundation

public protocol NewsFeedLoader {
     func load(completion: @escaping (NewsFeedRoot?,Error?) -> Void)
}
