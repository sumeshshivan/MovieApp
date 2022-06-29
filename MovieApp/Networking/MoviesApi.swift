//
//  IpasApi.swift
//  TMDB
//
//  Created by sumesh shivan on 09/03/22.
//

import Foundation
import Combine


class MoviesApi {
    private let httpClient: HTTPClient
    private let baseUrlProvider: BaseUrlProviding
    
    init(httpClient: HTTPClient = HTTPClient(), baseUrlProvider: BaseUrlProviding = BaseUrlProvider()) {
        self.httpClient = httpClient
        self.baseUrlProvider = baseUrlProvider
    }
    
    func fetchMovies(searchKey: String) -> AnyPublisher<BaseResponse<[Movie]>, Error> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrlProvider.baseUrl.host
        urlComponents.path = "/"
        urlComponents.queryItems = [
           URLQueryItem(name: "apiKey", value: APIKeys.omdbApiKey),
           URLQueryItem(name: "s", value: searchKey),
        ]
        let request =  URLRequest(url: urlComponents.url!)
        return httpClient.perform(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetail(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = baseUrlProvider.baseUrl.host
        urlComponents.path = "/"
        urlComponents.queryItems = [
           URLQueryItem(name: "apiKey", value: APIKeys.omdbApiKey),
           URLQueryItem(name: "i", value: imdbID),
        ]
        print("===> ", urlComponents.url)
        let request =  URLRequest(url: urlComponents.url!)
        return httpClient.perform(request)
            .map(\.value)
            .eraseToAnyPublisher()
    }
}
