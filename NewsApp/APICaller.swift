//
//  APICaller.swift
//  NewsApp
//
//  Created by Manan Patel on 2021-05-16.
//

import Foundation

class APICaller {
    static let shared = APICaller()
    
    //https://newsapi.org/v2/top-headlines?country=us&apiKey=53b50c107ff04fab932893969fd0974e
    
    struct Constants {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&apiKey=53b50c107ff04fab932893969fd0974e")
    }
    
    
    private init() {
        
    }
    
    public func getTopStories(completion: @escaping (Result<[Article],Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    completion(.success(result.articles))
                }
                catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}

struct APIResponse: Codable {
    let articles: [Article]
}

struct Article: Codable {
    let title: String
    let description: String?
    let url: String
    let urlToImage: String
    let publishedAt: String
    let source: Source
}

struct Source: Codable {
    let id: String?
    let name: String
}
