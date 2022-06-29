//
//  RemoteMovieDetailProvider.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import Foundation
import Combine

class RemoteMovieDetailProvider: MovieDetailProvider {
    let moviesApi: MoviesApi
    init(moviesApi: MoviesApi) {
        self.moviesApi = moviesApi
    }
    func getMovieDeatils(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
        moviesApi.fetchMovieDetail(imdbID: imdbID)
    }
}
