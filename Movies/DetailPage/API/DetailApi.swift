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
        let movieCastUrlString = baseURL + "movie/\(movieId)/credits?api_key=\(🔑)&language=\(appLanguage)"
        guard let castURL = URL(string: movieCastUrlString) else {
            return Observable<MovieCast>.empty()
        }
        
        let castRequest = URLRequest(url: castURL)
        
        return URLSession.shared.rx.decodable(request: castRequest, type: MovieCast.self)
    }
    
    func getMovieTrailer(with movieId: Int) -> Observable<MovieTrailers> {
        let movieTrailersUrlString = baseURL + "movie/\(movieId)/videos?api_key=\(🔑)&language=\(appLanguage)"
        guard let trailersURL = URL(string: movieTrailersUrlString) else {
            return Observable<MovieTrailers>.empty()
        }
        
        let trailerRequest = URLRequest(url: trailersURL)
        
        return URLSession.shared.rx.decodable(request: trailerRequest, type: MovieTrailers.self)
    }
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail> {
        
        let movieDetailUrlString = baseURL + "movie/\(movieId)?api_key=\(🔑)&language=\(appLanguage)"
        
        guard let detailURL = URL(string: movieDetailUrlString) else {
            return Observable<MovieDetail>.empty()
            
        }
        
        let detailRequest = URLRequest(url: detailURL)
        
        return URLSession.shared.rx.decodable(request: detailRequest, type: MovieDetail.self)
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
