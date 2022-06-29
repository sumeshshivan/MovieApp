//
//  MoviesListingViewModel.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import Foundation
import Combine
import CoreData

class MoviesListingViewModel: ObservableObject {

    let context = PersistenceController.shared.container.viewContext
    
    let moviesProvider: SearchedMoviesProvider
    
    var subscription: Set<AnyCancellable> = []
    
    @Published var searchKey: String = String()
    @Published var isLoading: Bool = false
    @Published private (set) var movies: [Movie] = []
    
    init(moviesProvider: SearchedMoviesProvider) {
        self.moviesProvider = moviesProvider
        createSubscriptions()
    }
    
    private func createSubscriptions() {
        $searchKey
            // debounces the string publisher, such that it delays the process of sending request to remote server.
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .map({ (string) -> String? in
                if string.count < 1 {
                    self.movies = []
                    return nil
                }
                return string
            }) // prevents sending numerous requests and sends nil if the count of the characters is less than 1.
            .compactMap{ $0 } // removes the nil values so the search string does not get passed down to the publisher chain
            .sink { (_) in
                //
            } receiveValue: { [self] (searchField) in
                searchMovies(searchKey: searchField)
            }.store(in: &subscription)
    }
    
    private func searchMovies(searchKey: String) {
        guard searchKey != "" else { return }
        isLoading = true
        moviesProvider.searchMovies(searchKey: searchKey)
            .receive(on: RunLoop.main)
            .sink { [self] (completed) in
                self.isLoading = false
            } receiveValue: { [self] (searchedMovies) in
                self.movies = searchedMovies.Search ?? []
                self.saveMoviesToDB()
            }.store(in: &subscription)
    }

    private func saveMoviesToDB() {
        for movie in movies {
            let searchedMovie: SearchedMovie!

            let fetchUser: NSFetchRequest<SearchedMovie> = SearchedMovie.fetchRequest()
            fetchUser.predicate = NSPredicate(format: "imdbID = %@", movie.imdbID)

            let results = try? context.fetch(fetchUser)

            if results?.count == 0 {
                searchedMovie = SearchedMovie(context: context)
            } else {
                searchedMovie = results?.first
            }

            searchedMovie.title = movie.Title
            searchedMovie.poster = movie.Poster
            searchedMovie.year = movie.Year
            searchedMovie.imdbID = movie.imdbID
        }

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

}
