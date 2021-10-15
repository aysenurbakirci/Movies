//
//  MockMainApi.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

@testable import Movies
import RxSwift

class MockMainApi: MainApiProtocol {
    
    func getPopularMovies(page: Int) -> Observable<Movies> {
        
        guard let bundleURL = Bundle.main.url(forResource: "MovieTestData", withExtension: "json") else {
            fatalError("Not find MovieTestData.json")
        }
        
        guard let movieData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        
        guard let movies = try? JSONDecoder().decode(Movies.self, from: movieData) else {
            fatalError()
        }
        
        return Observable.just(movies)
    }
    
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])> {
        return Observable<(movies: [Movie], people: [Person])>.empty()
    }
}
