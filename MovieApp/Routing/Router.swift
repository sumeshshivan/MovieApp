//
//  File.swift
//  MovieApp
//
//  Created by sumesh shivan on 27/04/22.
//

import SwiftUI

class Router {
    
    let moviesApi: MoviesApi
    
    init(moviesApi: MoviesApi) {
        self.moviesApi = moviesApi
    }

    @ViewBuilder func searchHistoryView() -> some View {
        MovieSearchHistoryView()
    }
    
    @ViewBuilder func movieListingView() -> some View {
        MovieListingView(
            _viewModel: MoviesListingViewModel(
                moviesProvider: RemoteSearchedMoviesProvider(
                    moviesApi: moviesApi
                )
            )
        )
    }
    
    @ViewBuilder func movieDetailView(movie: Movie) -> some View {
        MovieDetailView(
            _viewModel: MoviesDetailViewModel(
                movie: movie,
                movieDetailProvider:
                    RemoteMovieDetailProvider(moviesApi: moviesApi)
            )
        )
    }

    @ViewBuilder func movieDetailView(searchedMovie: SearchedMovie) -> some View {
        let movie = Movie(
            Poster: searchedMovie.poster ?? "",
            Title: searchedMovie.title ?? "",
            Year: searchedMovie.year ?? "",
            imdbID: searchedMovie.imdbID ?? ""
        )
        MovieDetailView(
            _viewModel: MoviesDetailViewModel(
                movie: movie,
                movieDetailProvider:
                    RemoteMovieDetailProvider(moviesApi: moviesApi)
            )
        )
    }
}
