//
//  DataBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift

enum QueryType: String {
    case movie = "movie"
    case person = "person"
    case search = "search"
}
enum MovieQueryType: String {
    case detail = ""
    case cast = "credits"
    case trailer = "videos"
}
enum PersonQueryType: String {
    case detail = ""
    case credits = "movie_credits"
}
enum SearchType: String {
    case person = "person"
    case movie = "movie"
}

class DataBuilder<D: Decodable> {
    
    private var urlComponents = URLComponents()
    
    private let baseQueryItems = [
        URLQueryItem(name: "api_key", value: 🔑),
        URLQueryItem(name: "language", value: appLanguage.rawValue)
    ]
    
    func addBase(type: QueryType) -> DataBuilder<D> {
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "3"
        urlComponents.path = type.rawValue
        return self
    }
    
    func getPopularMovies(page: String) -> DataBuilder<D> {
        urlComponents.path = "popular"
        urlComponents.queryItems = baseQueryItems
        urlComponents.queryItems = [URLQueryItem(name: "page", value: page)]
        return self
    }
    
    func getMovieDetail(movieId: String, queryType: MovieQueryType) -> DataBuilder<D> {
        urlComponents.path = movieId
        
        if !queryType.rawValue.isEmpty {
            urlComponents.path = queryType.rawValue
        }
        urlComponents.queryItems = baseQueryItems
        return self
    }
    
    func getPersonDetail(personId: String, queryType: PersonQueryType) -> DataBuilder<D> {
        urlComponents.path = personId
        
        if !queryType.rawValue.isEmpty {
            urlComponents.path = queryType.rawValue
        }
        urlComponents.queryItems = baseQueryItems
        return self
    }
    
    func getSearchData(searchQuery: String, queryType: SearchType) -> DataBuilder<D> {
        urlComponents.path = queryType.rawValue
        urlComponents.queryItems = baseQueryItems
        urlComponents.queryItems = [URLQueryItem(name: "query", value: searchQuery)]
        return self
    }

    func build() -> Observable<D> {
        let url = urlComponents.url!
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.rx.decodable(request: urlRequest, type: D.self)
    }
}
