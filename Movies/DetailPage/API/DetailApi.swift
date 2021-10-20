//
//  DetailApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import RxSwift

protocol DetailApiProtocol {
    func getMovieCast(with movieId: Int) -> Observable<MovieCast>
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers>
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail>
    func getPersonDetail(with personId: Int) -> Observable<PersonDetail>
    func getPersonMovieCredits(with personId: Int) -> Observable<[MovieCredits]>
    func getDetails(movieId: Int) -> Observable<MovieDetail>
    func getDetails(personId: Int) -> Observable<PersonDetail>
    func getTrailerUrl(key: String) -> URL
}

struct DetailApi: DetailApiProtocol {
    
    func getMovieCast(with movieId: Int) -> Observable<MovieCast> {
        
        return DataBuilder<MovieCast>()
            .addBase(type: .movie)
            .getMovieDetail(movieId: String(movieId), queryType: .cast)
            .build()
    }
    
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers> {
        
        return DataBuilder<MovieTrailers>()
            .addBase(type: .movie)
            .getMovieDetail(movieId: String(movieId), queryType: .trailer)
            .build()
    }
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail> {
        
        return DataBuilder<MovieDetail>()
            .addBase(type: .movie)
            .getMovieDetail(movieId: String(movieId), queryType: .detail)
            .build()
    }
    
    func getPersonDetail(with personId: Int) -> Observable<PersonDetail> {
        
        return DataBuilder<PersonDetail>()
            .addBase(type: .person)
            .getPersonDetail(personId: String(personId), queryType: .detail)
            .build()
    }
    
    func getPersonMovieCredits(with personId: Int) -> Observable<[MovieCredits]> {
        
        return DataBuilder<PersonMovies>()
            .addBase(type: .person)
            .getPersonDetail(personId: String(personId), queryType: .credits)
            .build()
            .map(\.cast)
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
    
    func getDetails(personId: Int) -> Observable<PersonDetail> {
        let personDetail = getPersonDetail(with: personId)
        let personCredits = getPersonMovieCredits(with: personId)
        
        return Observable.zip(personDetail, personCredits)
            .map { (personDetail: $0, personCredits: $1) }
            .do(onNext: { data in
                data.personDetail.addMovieCast(movies: data.personCredits)
            })
            .map { $0.personDetail }
    }
    
    func getTrailerUrl(key: String) -> URL {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.youtube.com"
        urlComponents.path = "/watch"
        urlComponents.queryItems = [URLQueryItem(name: "v", value: key)]
        return urlComponents.url!
    }
}
