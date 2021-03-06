//
//  MockMainApi.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

@testable import Movies
import RxSwift
import ImdbAPI
import RxTest

class MockMainApi: MainApiProtocol {
    
    var scheduler: TestScheduler
    
    init(scheduler: TestScheduler) {
        self.scheduler = scheduler
    }
    
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
        return scheduler.createColdObservable([.next(10, movies)]).asObservable()
    }
    
    func searchMoviesAndPeople(with query: String, page: Int) -> Observable<(movies: [Movie], people: [Person])> {
        
        guard let bundleMovieURL = Bundle.main.url(forResource: "SearchMovie", withExtension: "json") else {
            fatalError("Not find SearchMovie.json")
        }
        guard let movieData = try? Data(contentsOf: bundleMovieURL) else {
            fatalError()
        }
        guard let movies = try? JSONDecoder().decode(Movies.self, from: movieData) else {
            fatalError()
        }
        
        guard let bundlePersonURL = Bundle.main.url(forResource: "SearchPerson", withExtension: "json") else {
            fatalError("Not find SearchPerson.json")
        }
        guard let personData = try? Data(contentsOf: bundlePersonURL) else {
            fatalError()
        }
        guard let people = try? JSONDecoder().decode(People.self, from: personData) else {
            fatalError()
        }
        
        return scheduler.createColdObservable([.next(5, (movies: movies.results, people: people.results))]).asObservable()
    }
}
