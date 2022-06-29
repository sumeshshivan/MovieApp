//
//  MovieDetailProvider.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import Foundation
import Combine

protocol MovieDetailProvider {
    func getMovieDeatils(imdbID: String) -> AnyPublisher<MovieDetail, Error>
}
