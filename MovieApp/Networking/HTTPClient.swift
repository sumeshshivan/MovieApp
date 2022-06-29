//
//  Agent.swift
//  TMDB
//
//  Created by sumesh shivan on 09/03/22.
//

import Foundation
import Combine

protocol BaseUrlProviding {
    var baseUrl: URL { get }
}

enum RequestError: Error {
    case apiError(error: Error)
}

extension URLRequest {
    func addingBearerAuthorization(token: String) -> URLRequest {
        var request = self
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    func acceptingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    func sendingJSON() -> URLRequest {
        var request = self
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

struct HTTPClient {

    struct Response<T> {
        let value: T
        let response: URLResponse
    }
    
    func perform<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        let jsonRequest = request.sendingJSON().acceptingJSON()
        return URLSession.shared
            .dataTaskPublisher(for: jsonRequest)
            .tryMap { result -> Response<T> in
//                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let value = try decoder.decode(T.self, from: result.data)
                return Response(value: value, response: result.response)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func performPost<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        var postRequest = request
        postRequest.httpMethod = "POST"
        return perform(postRequest, decoder)
    }
    
    func performGet<T: Decodable>(_ request: URLRequest, _ decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<Response<T>, Error> {
        var postRequest = request
        postRequest.httpMethod = "GET"
        return perform(postRequest, decoder)
    }
}
