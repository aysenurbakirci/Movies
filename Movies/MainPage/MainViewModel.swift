//
//  MainViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import RxSwift

final class MainViewModel: MainApi {
    
    func getPopularMovies(page: Int = 1) -> Observable<[Movie]> {
        
        guard let request = generatePopularMovieRequest(page: page) else {
            return Observable<[Movie]>.empty()
        }
        
        return URLSession.shared.rx
            .decodable(request: request, type: Movies.self)
            .map(\.results)
    }
    
    func searchMovieAndActor(searchQuery: String) -> Observable<(movies: [Movie], actors: [Actor])>  {
        
        guard let searchMovieRequest = generateSearchRequest(type: .movie, query: searchQuery),
              let searchActorRequest = generateSearchRequest(type: .person, query: searchQuery) else {
            return Observable<(movies: [Movie], actors: [Actor])>.empty()
        }
        
        let searchMovieObservable = URLSession.shared.rx
            .decodable(request: searchMovieRequest, type: Movies.self)
            .map(\.results)
        
        let searchActorObservable = URLSession.shared.rx
            .decodable(request: searchActorRequest, type: Actors.self)
            .map(\.results)
        
        return Observable
            .zip(searchMovieObservable, searchActorObservable)
            .map { (movies: $0, actors: $1) }
    }
}
