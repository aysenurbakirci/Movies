//
//  URLRequestBuilder.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 18.10.2021.
//

import RxSwift

public class URLRequestBuilder {
    
    public init() {}
    
    private var urlComponents = URLComponents()
    
    public func setScheme(_ scheme: String) -> URLRequestBuilder {
        urlComponents.scheme = scheme
        return self
    }
    
    public func setHost(_ host: String) -> URLRequestBuilder {
        urlComponents.host = host
        return self
    }
    
    public func addPathParam(_ path: String) -> URLRequestBuilder {
        urlComponents.path += path
        return self
    }
    
    public func addQueryParam(_ queryDict: [String : String]) -> URLRequestBuilder {
        var queryParams = [URLQueryItem]()
        
        for (name, value) in queryDict {
            queryParams.append(URLQueryItem(name: name, value: value))
        }
        
        var queryItems = urlComponents.queryItems ?? []
        queryItems.append(contentsOf: queryParams)
        urlComponents.queryItems = queryItems
        return self
    }

    public func build() -> URLRequest {
        let url = urlComponents.url!
        return URLRequest(url: url)
    }
}
