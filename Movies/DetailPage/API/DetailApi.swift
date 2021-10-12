//
//  DetailApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation

protocol DetailApi {}

extension DetailApi {
    
    func generateMovieDetailsRequest(type: MovieDetailType, id: Int, language: Language) -> URLRequest? {
        let urlString = baseURL + "movie/\(id)/\(type.rawValue)?api_key=\(🔑)&language=\(language.rawValue)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }

    func generateDetailPageRequest(type: CategoryType, id: Int, language: Language) -> URLRequest? {
        let urlString = baseURL + "\(type.rawValue)/\(id)?api_key=\(🔑)&language=\(language.rawValue)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }

    func generatePersonCreditsRequest(id: Int, language: Language) -> URLRequest? {
        let urlString = baseURL + "person/\(id)/movie_credits?api_key=\(🔑)&language=\(language.rawValue)"
        guard let url = URL(string: urlString) else { return nil }
        return URLRequest(url: url)
    }
    
}
