//
//  DetailApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import RxSwift
import ImdbAPI

protocol DetailApiProtocol {
    func getMovieCast(with movieId: Int) -> Observable<MovieCast>
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers>
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail>
    func getPersonDetail(with personId: Int) -> Observable<PersonDetail>
    func getPersonMovieCredits(with personId: Int) -> Observable<PersonMovies>
    func getDetails(movieId: Int) -> Observable<MovieDetail>
    func getDetails(personId: Int) -> Observable<PersonDetail>
    func createTrailerUrl(key: String) -> URL
}

struct DetailApi: DetailApiProtocol {
    
    func getMovieCast(with movieId: Int) -> Observable<MovieCast> {
        return ImdbService.getMovieCast(movieId: movieId)
    }
    
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers> {
        return ImdbService.getMovieTrailer(movieId: movieId)
    }
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail> {
        return ImdbService.getMovieDetail(movieId: movieId)
    }
    
    func getDetails(movieId: Int) -> Observable<MovieDetail> {
        
        let movieDetail = getMovieDetail(with: movieId)
        let movieCast = getMovieCast(with: movieId)
        let movieTrailers = getMovieTrailer(with: movieId)
        
        return Observable.zip(movieDetail, movieCast, movieTrailers)
            .map { (movieDetail: $0, movieCast: $1, movieTrailers: $2) }
            .do(onNext: { data in
                data.movieDetail.addMovieCast(movieCast: data.movieCast)
                data.movieDetail.addTrailers(movieTrailer: data.movieTrailers)
            })
            .map { $0.movieDetail }
    }
    
    func getPersonDetail(with personId: Int) -> Observable<PersonDetail> {
        return ImdbService.getPersonDetail(personId: personId)
    }
    
    func getPersonMovieCredits(with personId: Int) -> Observable<PersonMovies> {
        return ImdbService.getPersonMovieCredits(personId: personId)
    }
    
    func getDetails(personId: Int) -> Observable<PersonDetail> {
        let personDetail = getPersonDetail(with: personId)
        let personCredits = getPersonMovieCredits(with: personId)
        
        return Observable.zip(personDetail, personCredits)
            .map { (personDetail: $0, personCredits: $1) }
            .do(onNext: { data in
                data.personDetail.addMovieCast(movies: data.personCredits.cast)
            })
            .map { $0.personDetail }
    }
    
    func createTrailerUrl(key: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.youtube.com"
        urlComponents.path = "/watch"
        urlComponents.queryItems = [URLQueryItem(name: "v", value: key)]
        return urlComponents.url!
    }
}
