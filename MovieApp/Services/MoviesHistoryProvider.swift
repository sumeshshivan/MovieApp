//
//  MoviesHistoryProvider.swift
//  MovieApp
//
//  Created by sumesh shivan on 27/04/22.
//

import Foundation
import Combine

protocol MoviesHistoryProvider {
    func getHistory() -> AnyPublisher<[Movie], Error>
}
