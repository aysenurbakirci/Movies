//
//  DetailApi.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import RxSwift

protocol DetailApiProtocol {
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail>
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
    
    func getDetails(with movieId: Int) -> Observable<MovieDetail> {
        
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
}
