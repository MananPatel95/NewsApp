//
//  Article.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-18.
//

import Foundation

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let id: String?
    let name: String
}
