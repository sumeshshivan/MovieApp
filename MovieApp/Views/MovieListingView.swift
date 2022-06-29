//
//  MovieListingView.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import SwiftUI
import Combine

struct MovieListingView: View {
    @Environment(\.router) var router
    @ObservedObject private var viewModel: MoviesListingViewModel
    
    init(_viewModel: MoviesListingViewModel) {
        self.viewModel = _viewModel
    }
    
    @ViewBuilder
    func SearchView() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .padding(.trailing, 4)
                .foregroundColor(.white)
            TextField("", text: $viewModel.searchKey)
                .foregroundColor(.white)
                .placeholder(when: viewModel.searchKey.isEmpty) {
                    Text("Search movies").foregroundColor(Color(uiColor: .lightGray))
                }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: 50.0)
        .background(Color("DarkBGColor"))
        .cornerRadius(4.0)
    }
     
    @ViewBuilder
    func MovieView(movie: Movie) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            
            AsyncImage(url: URL(string: movie.Poster)) { phase in
                if let image = phase.image {
                    image.resizable()
                        .cornerRadius(4)
                        .frame(minWidth: 100)
                        .aspectRatio(contentMode: .fit)
                        .aspectRatio(0.75, contentMode: ContentMode.fill)
                } else if phase.error != nil {
                    ZStack {
                        Color("DarkBGColor")
                            .cornerRadius(4)
                            .frame(minWidth: 100)
                            .aspectRatio(0.75, contentMode: ContentMode.fill)
                        Text("No Poster")
                            .foregroundColor(.accentColor)
                    }
                } else {
                    ZStack {
                        Color("DarkBGColor")
                            .cornerRadius(4)
                            .frame(minWidth: 100)
                            .aspectRatio(0.75, contentMode: ContentMode.fill)
                        ProgressView()
                    }
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(movie.Title)
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(movie.Year)
                    .foregroundColor(Color.accentColor)
            }
        }
    }

    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(uiColor: .darkText)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 30.0) {
                    NavbarView()
                    SearchView()
                    if viewModel.isLoading {
                        ZStack {
                            Color(uiColor: .darkText)
                            ProgressView("Searching...")
                                .foregroundColor(.white)
                                .tint(.white)
                        }
                    } else if viewModel.movies.count == 0 {
                        ZStack {
                            Color(uiColor: .darkText)
                            VStack(spacing: 20.0) {
                                Image(systemName: "film")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                Text(
                                    viewModel.searchKey == "" ?
                                        "Start searching to view movies" :
                                        "No movies for this search. Try changing the search"
                                ).foregroundColor(Color.accentColor)
                            }
                        }
                    } else {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, spacing: 70) {
                                ForEach(viewModel.movies, id: \.imdbID) { movie in
                                    NavigationLink {
                                        router.movieDetailView(movie: movie)
                                    } label: {
                                        MovieView(movie: movie)
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }.padding(.horizontal, 20.0)
            }.navigationBarHidden(true)
        }
    }
}

struct MovieListingView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListingView(
            _viewModel: MoviesListingViewModel(
                moviesProvider: MockMoviesProvider()
            )
        )
    }
    
    class MockBaseUrlProviding: BaseUrlProviding {
        var baseUrl: URL = URL(fileURLWithPath: "")
    }

    class MockMovieDetailProvider: MovieDetailProvider {
        private let subject = PassthroughSubject<MovieDetail, Error>()

        func getMovieDeatils(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
            return subject.eraseToAnyPublisher()
        }
    }

    class MockMoviesProvider: SearchedMoviesProvider {
        private let subject = PassthroughSubject<BaseResponse<[Movie]>, Error>()

        func searchMovies(searchKey: String) -> AnyPublisher<BaseResponse<[Movie]>, Error> {
            return subject.eraseToAnyPublisher()
        }
    }
}
