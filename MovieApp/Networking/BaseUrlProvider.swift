//
//  DevBaseUrlProvider.swift
//  TMDB
//
//  Created by sumesh shivan on 09/03/22.
//

import Foundation

struct BaseUrlProvider: BaseUrlProviding {
    var baseUrl: URL = URL(string: "https://omdbapi.com")!
}
