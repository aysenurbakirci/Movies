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
        
        return DataBuilder<Movies>()
            .addBase(type: .movie)
            .getPopularMovies(page: String(page))
            .build()
    }
    
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])> {
        
        let searchMovie = DataBuilder<Movies>()
            .addBase(type: .search)
            .getSearchData(searchQuery: query, queryType: .movie)
            .build()
            .map(\.results)
        
        let searchPerson = DataBuilder<People>()
            .addBase(type: .search)
            .getSearchData(searchQuery: query, queryType: .person)
            .build()
            .map(\.results)
        
        return Observable
            .zip(searchMovie, searchPerson)
            .map { (movies: $0, people: $1) }
    }
}

