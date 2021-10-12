//
//  URLSession+Rx.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import Foundation
import RxSwift

public enum RxURLSessionError: Error {
  case unknown
  case invalidResponse(response: URLResponse)
  case requestFailed(response: HTTPURLResponse, data: Data?)
  case deserializationFailed
}

extension Reactive where Base: URLSession {
    
    func response(request: URLRequest) -> Observable<(HTTPURLResponse, Data)> {
        
      return Observable.create { observer in
        
        let task = self.base.dataTask(with: request) { data, response, error in
            
          guard let response = response, let data = data else {
            observer.onError(error ?? RxURLSessionError.unknown)
            return
          }

          guard let httpResponse = response as? HTTPURLResponse else {
            observer.onError(RxURLSessionError.invalidResponse(response: response))
            return
          }

          observer.onNext((httpResponse, data))
          observer.onCompleted()
        }
        
        task.resume()

        return Disposables.create { task.cancel() }
      }
    }
    
    func decodable<D: Decodable>(request: URLRequest, type: D.Type) -> Observable<D> {
        
        return response(request: request).map { response, data -> Data in
            
          guard 200 ..< 300 ~= response.statusCode else {
            throw RxURLSessionError.requestFailed(response: response, data: data)
          }

          return data
            
        }
        .map { data in
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
        }
    }
}