//
//  ImdbService.swift
//  MoviesAPI
//
//  Created by Ayşenur Bakırcı on 1.11.2021.
//

import RxSwift

public class ImdbService {

    public class func call<T: Decodable>(api: ImdbAPI) -> Observable<T> {
        let request = URLRequestBuilder()
            .withScheme(api.schema)
            .withHost(api.host)
            .withPathParam(api.version)
            .withPathParam(api.path)
            .withQueryParam(api.apiKey)
            .withQueryParam(api.language)
            .withQueryParam(api.queryItems)
            .build()
        
        return URLSession.shared.rx.decodable(request: request, type: T.self)
    }
}

public extension ImdbService {
    
    class func getPopularMovies(page: Int) -> Observable<Movies> {
        let api = MovieAPI.popular(page: page)
        return call(api: api)
    }
    
    class func getMovieDetail(movieId: Int) -> Observable<MovieDetail> {
        let api = MovieAPI.detail(id: movieId)
        return call(api: api)
    }
    
    class func getMovieCast(movieId: Int) -> Observable<MovieCast> {
        let api = MovieAPI.cast(id: movieId)
        return call(api: api)
    }
    
    class func getMovieTrailer(movieId: Int) -> Observable<MovieTrailers> {
        let api = MovieAPI.trailer(id: movieId)
        return call(api: api)
    }
    
    class func getPersonDetail(personId: Int) -> Observable<PersonDetail> {
        let api = PersonAPI.detail(id: personId)
        return call(api: api)
    }
    
    class func getPersonMovieCredits(personId: Int) -> Observable<PersonMovies> {
        let api = PersonAPI.movieCredits(id: personId)
        return call(api: api)
    }
    
    class func searchMovies(query: String) -> Observable<Movies> {
        let api = SearchAPI.movie(query: query)
        return call(api: api)
    }
    
    class func searchPeople(query: String) -> Observable<People> {
        let api = SearchAPI.person(query: query)
        return call(api: api)
    }
}
