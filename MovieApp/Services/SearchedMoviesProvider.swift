//
//  MoviesProvider.swift
//  TMDB
//
//  Created by sumesh shivan on 16/03/22.
//

import Foundation
import Combine

protocol SearchedMoviesProvider {
    func searchMovies(searchKey: String) -> AnyPublisher<BaseResponse<[Movie]>, Error>
}
