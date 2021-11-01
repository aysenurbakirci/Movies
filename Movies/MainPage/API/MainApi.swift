//
//  MainPageApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation
import RxSwift
import MoviesAPI

protocol MainApiProtocol {
    
    func getPopularMovies(page: Int) -> Observable<Movies>
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])>
}

struct MainApi: MainApiProtocol {
    
    func getPopularMovies(page: Int) -> Observable<Movies> {
        return ImdbService.getPopularMovies(page: page)
    }
    
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])> {
        let searchMovie = ImdbService.searchMovies(query: query)
        let searchPerson = ImdbService.searchPeople(query: query)
        
        return Observable
            .zip(searchMovie, searchPerson)
            .map { (movies: $0.results, people: $1.results) }
    }
}

