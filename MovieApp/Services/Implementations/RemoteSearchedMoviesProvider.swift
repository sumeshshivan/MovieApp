//
//  PopularMoviesProvider.swift
//  TMDB
//
//  Created by sumesh shivan on 17/03/22.
//

import Foundation
import Combine

class RemoteSearchedMoviesProvider: SearchedMoviesProvider {
    let moviesApi: MoviesApi
    init(moviesApi: MoviesApi) {
        self.moviesApi = moviesApi
    }
    func searchMovies(searchKey: String) -> AnyPublisher<BaseResponse<[Movie]>, Error> {
        moviesApi.fetchMovies(searchKey: searchKey)
    }
}
