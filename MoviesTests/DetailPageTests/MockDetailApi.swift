//
//  MockDetailApi.swift
//  MoviesTests
//
//  Created by Ayşenur Bakırcı on 20.10.2021.
//

@testable import Movies
import RxSwift

class MockDetailApi: DetailApiProtocol {
    
    func getMovieCast(with movieId: Int) -> Observable<MovieCast> {
        guard let bundleURL = Bundle.main.url(forResource: "MovieCast", withExtension: "json") else {
            fatalError("Not find MovieCast.json")
        }
        guard let movieData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        guard let cast = try? JSONDecoder().decode(MovieCast.self, from: movieData) else {
            fatalError()
        }
        
        return Observable.just(cast)
    }
    
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers> {
        guard let bundleURL = Bundle.main.url(forResource: "MovieTrailer", withExtension: "json") else {
            fatalError("Not find MovieTrailer.json")
        }
        guard let movieData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        guard let trailer = try? JSONDecoder().decode(MovieTrailers.self, from: movieData) else {
            fatalError()
        }
        
        return Observable.just(trailer)
    }
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail> {
        guard let bundleURL = Bundle.main.url(forResource: "MovieDetail", withExtension: "json") else {
            fatalError("Not find MovieDetail.json")
        }
        guard let movieData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        guard let detail = try? JSONDecoder().decode(MovieDetail.self, from: movieData) else {
            fatalError()
        }
        
        return Observable.just(detail)
    }
    
    func getPersonDetail(with personId: Int) -> Observable<PersonDetail> {
        guard let bundleURL = Bundle.main.url(forResource: "PersonDetail", withExtension: "json") else {
            fatalError("Not find MovieDetail.json")
        }
        guard let personData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        guard let personDetail = try? JSONDecoder().decode(PersonDetail.self, from: personData) else {
            fatalError()
        }
        
        return Observable.just(personDetail)
    }
    
    func getPersonMovieCredits(with personId: Int) -> Observable<[MovieCredits]> {
        guard let bundleURL = Bundle.main.url(forResource: "PersonMovies", withExtension: "json") else {
            fatalError("Not find MovieDetail.json")
        }
        guard let personData = try? Data(contentsOf: bundleURL) else {
            fatalError()
        }
        guard let personMovies = try? JSONDecoder().decode(PersonMovies.self, from: personData) else {
            fatalError()
        }
        
        return Observable.just(personMovies).map(\.cast)
    }
    
    func getDetails(movieId: Int) -> Observable<MovieDetail> {
        let detail = getMovieDetail(with: movieId)
        let cast = getMovieCast(with: movieId)
        let trailer = getMovieTrailer(with: movieId)
        
        return Observable.zip(detail, cast, trailer)
            .map { (detail: $0, cast: $1, trailer: $2) }
            .do(onNext: { data in
                data.detail.addMovieCast(movieCast: data.cast)
                data.detail.addTrailers(movieTrailer: data.trailer)
            })
            .map { $0.detail }
    }
    
    func getDetails(personId: Int) -> Observable<PersonDetail> {
        let detail = getPersonDetail(with: personId)
        let cast = getPersonMovieCredits(with: personId)
        
        return Observable.zip(detail, cast)
            .map { (detail: $0, cast: $1) }
            .do(onNext: { data in
                data.detail.addMovieCast(movies: data.cast)
            })
            .map { $0.detail }
    }
    
    func getTrailerUrl(key: String) -> URL {
        return URL(string: key)!
    }
    
}
