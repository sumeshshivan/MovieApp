//
//  MovieSearchHistoryView.swift
//  MovieApp
//
//  Created by sumesh shivan on 27/04/22.
//

import SwiftUI

struct MovieSearchHistoryView: View {
    @Environment(\.router) var router
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @FetchRequest(
        entity: SearchedMovie.entity(),
        sortDescriptors: []
    ) var movies: FetchedResults<SearchedMovie>

    private var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
        GridItem(.adaptive(minimum: 100), spacing: 20, alignment: .top),
    ]

    var backButton : some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            HStack(spacing: 0) {
                Image("back")
                    .font(.title2)
                Text("")
            }
        }
    }

    @ViewBuilder
    func MovieView(searchedMovie: SearchedMovie) -> some View {
        VStack(alignment: .leading, spacing: 15) {

            AsyncImage(url: URL(string: searchedMovie.poster ?? "")) { phase in
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
                Text(searchedMovie.title ?? "")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                Text(searchedMovie.year ?? "")
                    .foregroundColor(Color.accentColor)
            }
        }
    }
    
    var body: some View {
            ZStack(alignment: .top) {
                Color(uiColor: .darkText)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 30.0) {
                    if movies.count == 0 {
                        ZStack {
                            Color(uiColor: .darkText)
                            VStack(spacing: 20.0) {
                                Image(systemName: "film")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.gray)
                                Text("No search history found.")
                                    .foregroundColor(Color.accentColor)
                            }
                        }
                    } else {
                        ScrollView(.vertical) {
                            LazyVGrid(columns: columns, spacing: 70) {
                                ForEach(movies, id: \.imdbID) { movie in
                                    NavigationLink(destination: router.movieDetailView(searchedMovie: movie)) {
                                        MovieView(searchedMovie: movie)
                                    }
                                }
                            }
                        }
                    }
                }.padding(.horizontal, 20.0)
            }
            .navigationTitle("Search History")
            .onAppear() {
                UINavigationBar.appearance().tintColor = .clear
                UINavigationBar.appearance().backIndicatorImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
                UINavigationBar.appearance().backIndicatorTransitionMaskImage = UIImage(named: "back")?.withRenderingMode(.alwaysOriginal)
            }

    }
}

struct MovieSearchHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        MovieSearchHistoryView()
    }
}
