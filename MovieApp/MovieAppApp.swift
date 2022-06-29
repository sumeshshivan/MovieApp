//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by sumesh shivan on 24/04/22.
//

import SwiftUI

@main
struct MovieAppApp: App {
    let persistenceController = PersistenceController.shared
    
    let router = Router(
        moviesApi: MoviesApi(
            httpClient: HTTPClient(),
            baseUrlProvider: BaseUrlProvider()
        )
    )

    var body: some Scene {
        WindowGroup {
            router.movieListingView()
            .environment(\.managedObjectContext, persistenceController.container.viewContext)
            .environment(\.router, router)
        }
    }
}

private struct RouterKey: EnvironmentKey {
    static let defaultValue: Router = Router(
        moviesApi: MoviesApi(
            httpClient: HTTPClient(),
            baseUrlProvider: BaseUrlProvider()
        )
    )

}

extension EnvironmentValues {
    var router: Router {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}
