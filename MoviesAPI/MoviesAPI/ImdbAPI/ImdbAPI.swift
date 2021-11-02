//
//  ImdbAPI.swift
//  MoviesAPI
//
//  Created by Ayşenur Bakırcı on 1.11.2021.
//

import Foundation
import RxSwift

public protocol ImdbAPI {
    var schema: String { get }
    var host: String { get }
    var version: String { get }
    var apiKey: String { get }
    var language: String { get }
    var path: String { get }
    var queryItems: [String: String] { get }
}

public extension ImdbAPI {
    var schema: String {
        return "https"
    }
    
    var host: String {
        return "api.themoviedb.org"
    }
    
    var version: String {
        return "/3"
    }
    
    var apiKey: [String: String] {
        return ["api_key": "96c151da77643172f784ee17f262df9a"]
    }
    
    var language: [String: String] {
        return ["language": "en-US"]
    }
}

public enum MovieAPI: ImdbAPI {
    case popular(page: Int), detail(id: Int), cast(id: Int), trailer(id: Int)
    
    public var path: String {
        switch self {
        case .popular:
            return "/movie/popular"
        case .detail(let movieId):
            return "/movie/\(movieId)"
        case .cast(let movieId):
            return "/movie/\(movieId)/credits"
        case .trailer(let movieId):
            return "/movie/\(movieId)/videos"
        }
    }
    
    public var queryItems: [String : String] {
        switch self {
        case .popular(let page):
            return ["page" : "\(page)"]
        default:
            return [:]
        }
    }
}

public enum PersonAPI: ImdbAPI {
    case detail(id: Int), movieCredits(id: Int)
    
    public var path: String {
        switch self {
        case .detail(let personId):
            return "/person/\(personId)"
        case .movieCredits(let personId):
            return "/person/\(personId)/movie_credits"
        }
    }
    
    public var queryItems: [String : String] {
        return [:]
    }
}

public enum SearchAPI: ImdbAPI {
    case movie(query: String), person(query: String)
    
    public var path: String {
        switch self {
        case .movie(_):
            return "/search/movie"
        case .person(_):
            return "/search/person"
        }
    }
    
    public var queryItems: [String: String] {
        switch self {
        case .movie(let query):
            return ["query": query]
        case .person(let query):
            return ["query": query]
        }
    }
}
