//
//  NewsRootMocked.swift
//  NewsFeedTests
//
//  Created by mustafa salah eldin on 9/27/21.
//

import Foundation

class NewsFeedMocking {
    
    static let newsRootMockedJson =
        ["status": "ok",
         "totalResults": 2957,
         "articles": [
            [
                "source": [
                    "id": nil,
                    "name": "Business 2 Community"
                ],
                "author": "Andres Muñoz",
                "title": "What is a Brand Community?",
                "description": "Have you noticed that the biggest brands most of the time also have a passionate brand community? A community of…",
                "url": "https://www.business2community.com/online-communities/what-is-a-brand-community-02431718",
                "urlToImage": "https://cdn.business2community.com/wp-content/uploads/2021/09/pexels-dio-hasbi-saniskoro-3280130-2048x1365-1-900x600.jpeg",
                "publishedAt": "2021-09-20T13:00:28Z",
                "content": "Have you noticed that the biggest brands most of the time also have a passionate brand community?\r\nA community of people so passionate about the brand that each time a new product launches, they need… [+6863 chars]"
            ] ]
        ] as [String : Any]
    
}
