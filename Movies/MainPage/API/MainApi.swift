//
//  MainPageApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

protocol MainApi {}

extension MainApi {
    
    func generatePopularMovieRequest(language: Language, page: Int = 1) -> URLRequest? {
        let urlString = baseURL + "movie/popular?api_key=\(🔑)&language=\(language.rawValue)&page=\(page)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
    func generateSearchRequest(type: CategoryType, query: String, language: Language, page: Int = 1) -> URLRequest? {
        let urlString =  baseURL + "search/\(type.rawValue)?api_key=\(🔑)&language=\(language.rawValue)&query=\(query)&page=\(page)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
}

