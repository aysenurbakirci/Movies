//
//  DataBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import Foundation
import RxSwift

let baseImageURL = "https://image.tmdb.org/t/p/"

enum QueryType: String {
    case movie = "/movie"
    case person = "/person"
    case search = "/search"
}
enum MovieQueryType: String {
    case detail = ""
    case cast = "/credits"
    case trailer = "/videos"
}
enum PersonQueryType: String {
    case detail = ""
    case credits = "/movie_credits"
}
enum SearchType: String {
    case person = "/person"
    case movie = "/movie"
}

class DataBuilder<D: Decodable> {
    
    private var urlComponents = URLComponents()
    
    private let baseQueryItems = [
        URLQueryItem(name: "api_key", value: "96c151da77643172f784ee17f262df9a"),
        URLQueryItem(name: "language", value: "en-US")
    ]
    
    func addBase(type: QueryType) -> DataBuilder<D> {
        urlComponents.scheme = "https"
        urlComponents.host = "api.themoviedb.org"
        urlComponents.path = "/3" + type.rawValue
        return self
    }
    
    func getPopularMovies(page: String) -> DataBuilder<D> {
        urlComponents.path += "/popular"
        let item = [URLQueryItem(name: "page", value: page)]
        urlComponents.queryItems = baseQueryItems + item
        return self
    }
    
    func getMovieDetail(movieId: String, queryType: MovieQueryType) -> DataBuilder<D> {
        urlComponents.path += movieId
        
        if !queryType.rawValue.isEmpty {
            urlComponents.path += queryType.rawValue
        }
        urlComponents.queryItems = baseQueryItems
        return self
    }
    
    func getPersonDetail(personId: String, queryType: PersonQueryType) -> DataBuilder<D> {
        urlComponents.path += personId
        
        if !queryType.rawValue.isEmpty {
            urlComponents.path += queryType.rawValue
        }
        urlComponents.queryItems = baseQueryItems
        return self
    }
    
    func getSearchData(searchQuery: String, queryType: SearchType) -> DataBuilder<D> {
        urlComponents.path += queryType.rawValue
        let item = [URLQueryItem(name: "query", value: searchQuery)]
        urlComponents.queryItems = baseQueryItems + item
        return self
    }

    func build() -> Observable<D> {
        let url = urlComponents.url!
        let urlRequest = URLRequest(url: url)
        return URLSession.shared.rx.decodable(request: urlRequest, type: D.self)
    }
}
