//
//  MainPageApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation
import RxSwift

protocol MainApiProtocol {
    
    func getPopularMovies(page: Int) -> Observable<Movies>
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])>
}

struct MainApi: MainApiProtocol {
    
    func getPopularMovies(page: Int) -> Observable<Movies> {
        
        let urlString = baseURL + "movie/popular?api_key=\(🔑)&language=\(appLanguage)&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            return Observable<Movies>.error("Error" as! Error)
        }
        
        let popularRequest = URLRequest(url: url)
        
        return URLSession.shared.rx
            .decodable(request: popularRequest, type: Movies.self)
    }
    
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])> {
        
        let movieURLString =  baseURL + "search/movie?api_key=\(🔑)&language=\(appLanguage)&query=\(query)&page=\(page)"
        let personURLString =  baseURL + "search/person?api_key=\(🔑)&language=\(appLanguage)&query=\(query)&page=\(page)"  
        
        guard let movieURL = URL(string: movieURLString), let personURL = URL(string: personURLString) else {
            return Observable<(movies: [Movie], people: [Person])>.empty()
        }
        
        let movieRequest = URLRequest(url: movieURL)
        let personRequest = URLRequest(url: personURL)
        
        let searchMovieObservable = URLSession.shared.rx
            .decodable(request: movieRequest, type: Movies.self)
            .map(\.results)
        
        let searchPersonObservable = URLSession.shared.rx
            .decodable(request: personRequest, type: People.self)
            .map(\.results)
        
        return Observable
            .zip(searchMovieObservable, searchPersonObservable)
            .map { (movies: $0, people: $1) }
        
    }
}

