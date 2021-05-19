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
        static let topHeadlinesURL = "https://newsapi.org/v2/top-headlines?apiKey=53b50c107ff04fab932893969fd0974e&country="
        static let searchURLString = "https://newsapi.org/v2/everything?apiKey=53b50c107ff04fab932893969fd0974e&q="
        static let baseURLwithAPIKey = "https://newsapi.org/v2/top-headlines?"
        static let apiKey = "&apiKey=53b50c107ff04fab932893969fd0974e"
        static let country = "&country="
        static let category = "category="
    }
    
    private init() {
        
    }
    
    public func getTopStories(country: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !country.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let urlString = Constants.topHeadlinesURL + country
        guard let url = URL(string: urlString) else {return}
        
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
    
    public func searchWithQuery(query: String, completion: @escaping (Result<[Article],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        let urlString = Constants.searchURLString + query
        
        guard let url = URL(string: urlString) else {return}
        
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
    
    public func searchWithTopics(topic: String, country: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !topic.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        let urlString = Constants.baseURLwithAPIKey + Constants.category + topic.lowercased() + Constants.country + country + Constants.apiKey
        print(urlString)
        guard let url = URL(string: urlString) else {return}
        
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
