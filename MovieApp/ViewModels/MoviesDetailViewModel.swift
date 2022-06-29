//
//  MoviesDetailViewModel.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import UIKit
import Combine

class MoviesDetailViewModel: ObservableObject {
    var subscription: Set<AnyCancellable> = []
    let movieDetailProvider: MovieDetailProvider
    
    @Published var searchKey: String = String()
    @Published var isLoading: Bool = false
    @Published var movie: Movie
    @Published private (set) var movieDetail: MovieDetail?
    @Published private (set) var genres: [String] = []
    @Published private (set) var language: String = ""
    @Published private (set) var director: String = ""
    @Published private (set) var writer: String = ""
    @Published private (set) var actors: String = ""
    
    init(movie: Movie, movieDetailProvider: MovieDetailProvider) {
        self.movie = movie
        self.movieDetailProvider = movieDetailProvider
    }

    func update() {
        isLoading = true
    }

    func getMovieDeatils() {
        isLoading = true
        movieDetailProvider.getMovieDeatils(imdbID: movie.imdbID)
            .receive(on: RunLoop.main)
            .sink { [self] (completed) in
                self.isLoading = false
            } receiveValue: { [self] (movieDetail) in
                self.movieDetail = movieDetail
                self.genres = movieDetail.Genre.components(separatedBy: ", ")
                self.language = movieDetail.Language.components(separatedBy: ", ").first ?? ""
                self.director = "Director: \(movieDetail.Director)"
                self.writer = "Writer: \(movieDetail.Writer)"
                self.actors = "Actors: \(movieDetail.Actors)"
                self.objectWillChange.send()
            }.store(in: &subscription)
    }
    
}
