//
//  NewsFeedModel.swift
//  NewsFeed
//
//  Created by mustafa salah eldin on 9/28/21.
//

import Foundation

public class NewsFeedRoot: Decodable {
    public let status: String?
    public let totalResults: Int?
    public let articles: [Article]?
}

public class Article: Decodable {
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

public class ArticleSource: Decodable {
    let id: Int?
    let name: String?
}
