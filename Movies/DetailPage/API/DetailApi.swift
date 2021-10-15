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
    
    func getMovieDetail(with movieId: Int) -> Observable<MovieDetail> {
        
        let movieDetailUrlString = baseURL + "movie/\(movieId)?api_key=\(🔑)&language=\(appLanguage)"
        let movieCastUrlString = baseURL + "movie/\(movieId)/credits?api_key=\(🔑)&language=\(appLanguage)"
        let movieTrailersUrlString = baseURL + "movie/\(movieId)/videos?api_key=\(🔑)&language=\(appLanguage)"
        
        guard let detailURL = URL(string: movieDetailUrlString), let castURL = URL(string: movieCastUrlString), let trailersURL = URL(string: movieTrailersUrlString) else {
            return Observable<MovieDetail>.empty()
        }
        
        let detailRequest = URLRequest(url: detailURL)
        let castRequest = URLRequest(url: castURL)
        let trailersRequest = URLRequest(url: trailersURL)
        
        let movieDetail = URLSession.shared.rx.decodable(request: detailRequest, type: MovieDetail.self)
        let movieCast = URLSession.shared.rx.decodable(request: castRequest, type: MovieCast.self)
        let movieTrailers = URLSession.shared.rx.decodable(request: trailersRequest, type: MovieTrailers.self)
        
        return Observable.zip(movieDetail, movieCast, movieTrailers)
            .map { (movieDetail: $0, movieCast: $1, movieTrailers: $2) }
            .do(onNext: { data in
                data.movieDetail.addMovieCast(movieCast: data.movieCast)
                data.movieDetail.addTrailers(movieTrailer: data.movieTrailers)
            })
            .map { $0.movieDetail }
    }
}
