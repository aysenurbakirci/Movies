//
//  MainPageApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation
import RxSwift

protocol MainApiProtocol {
    
    func getPopularMovies() -> Observable<[Movie]>
    func searchMoviesAndPersons(query: String) -> Observable<(movies: [Movie], persons: [Actor])>
}

struct MainApi: MainApiProtocol {
    
    func getPopularMovies() -> Observable<[Movie]> {
        
        let urlString = baseURL + "movie/popular?api_key=\(🔑)&language=\(appLanguage)"
        
        guard let url = URL(string: urlString) else {
            return Observable<[Movie]>.empty()
        }
        
        let popularRequest = URLRequest(url: url)
        
        return URLSession.shared.rx
            .decodable(request: popularRequest, type: Movies.self)
            .map(\.results)
    }
    
    func searchMoviesAndPersons(query: String) -> Observable<(movies: [Movie], persons: [Actor])> {
        
        let movieURLString =  baseURL + "search/movie?api_key=\(🔑)&language=\(appLanguage)&query=\(query)"
        let personURLString =  baseURL + "search/person?api_key=\(🔑)&language=\(appLanguage)&query=\(query)"
        
        guard let movieURL = URL(string: movieURLString), let personURL = URL(string: personURLString) else {
            return Observable<(movies: [Movie], persons: [Actor])>.empty()
        }
        
        let movieRequest = URLRequest(url: movieURL)
        let personRequest = URLRequest(url: personURL)
        
        let searchMovieObservable = URLSession.shared.rx
            .decodable(request: movieRequest, type: Movies.self)
            .map(\.results)
        
        let searchPersonObservable = URLSession.shared.rx
            .decodable(request: personRequest, type: Actors.self)
            .map(\.results)
        
        return Observable
            .zip(searchMovieObservable, searchPersonObservable)
            .map { (movies: $0, persons: $1) }
        
    }
}

