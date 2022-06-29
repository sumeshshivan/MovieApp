//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import SwiftUI
import Combine

struct MovieDetailView: View {
    @ObservedObject private var viewModel: MoviesDetailViewModel
    
    init(_viewModel: MoviesDetailViewModel) {
        self.viewModel = _viewModel
    }
    
    @ViewBuilder
    func cardView() -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.movie.Title)
                    .font(.title)
                    .fontWeight(.semibold)
                HStack(spacing: 30) {
                    HStack {
                        Image(systemName: "star").foregroundColor(.accentColor)
                        Text(viewModel.movieDetail?.imdbRating ?? "")
                            .font(.subheadline)
                    }
                    HStack {
                        Image(systemName: "clock").foregroundColor(.accentColor)
                        Text(viewModel.movieDetail?.Runtime ?? "")
                            .font(.subheadline)
                    }
                }
                HStack {
                    Text(viewModel.language)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Spacer()
                    HStack {
                        ForEach(viewModel.genres, id: \.self) { genre in
                            Text(genre)
                                .font(.system(size: 11))
                                .fontWeight(.semibold)
                                .padding(4)
                                .padding(.horizontal, 6)
                                .background(Color(uiColor: .darkGray))
                                .background(.ultraThinMaterial)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding(.top, 20)
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 0.25)
                    .foregroundColor(.gray)
                    .padding(.vertical, 10)
                Text(viewModel.movieDetail?.Plot ?? "").lineSpacing(8)
                VStack(alignment: .leading, spacing: 6) {
                    Text(viewModel.director)
                    Text(viewModel.writer)
                    Text(viewModel.actors)
                }.padding(.top, 16)
            }.foregroundColor(.white)
            Spacer()
        }.padding(20)
    }
    
    var body: some View {
        ZStack {
            Color(uiColor: .darkText)
                .ignoresSafeArea()
            VStack {
                AsyncImage(url: URL(string: viewModel.movie.Poster)) { phase in
                    if let image = phase.image {
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ZStack {
                            Color("DarkBGColor")
                            ProgressView()
                        }
                    }
                }
                .ignoresSafeArea()
                Spacer()
            }
            Rectangle()
                .foregroundColor(.clear)
                .background(
                    LinearGradient(
                        gradient: Gradient(
                            colors: [.clear, .black, .black]
                        ),
                        startPoint: .top, endPoint: .bottom
                    )
                )
            VStack {
                Spacer()
                ZStack(alignment: .top){
                    Rectangle()
                        .background(.ultraThinMaterial)
                        .frame(maxWidth: .infinity, maxHeight: 500.0)
                        .cornerRadius(10.0)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(
                                    colors: [.clear, .black, .black]
                                ),
                                startPoint: .top, endPoint: .bottom
                            )
                        )
                    if viewModel.isLoading {
                        ZStack {
                            Color.clear
                            ProgressView()
                                .foregroundColor(.white)
                                .tint(.white)
                        }.frame(maxWidth: .infinity, maxHeight: 500.0)
                    } else {
                        cardView()
                    }
                }
            }
            .padding()
        }
        .onAppear() {
            UINavigationBar.appearance().tintColor = .clear
            UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
            UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
            viewModel.getMovieDeatils()
        }
        .toolbar {
            Button(action: {
                viewModel.getMovieDeatils()
            }) {
                Image(systemName: "arrow.clockwise")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 16)
                    .padding(6)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(16)
            }

        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(
            _viewModel: MoviesDetailViewModel(
                movie: Movie(
                    Poster: "https://m.media-amazon.com/images/M/MV5BMGVmMWNiMDktYjQ0Mi00MWIxLTk0N2UtN2ZlYTdkN2IzNDNlXkEyXkFqcGdeQXVyODE5NzE3OTE@._V1_SX300.jpg",
                    Title: "Ant Man and the Wasp",
                    Year: "2020",
                    imdbID: "1234"),
                movieDetailProvider: MockMovieDetailProvider()
            )
        )
    }
    
    class MockMovieDetailProvider: MovieDetailProvider {
        private let subject = PassthroughSubject<MovieDetail, Error>()
        
        func getMovieDeatils(imdbID: String) -> AnyPublisher<MovieDetail, Error> {
            return subject.eraseToAnyPublisher()
        }
    }
}
