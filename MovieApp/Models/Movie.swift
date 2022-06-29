//
//  Movie.swift
//  TMDB
//
//  Created by sumesh shivan on 16/03/22.
//

import Foundation

struct Movie: Decodable {
    var Poster: String
    var Title: String
    var Year: String
    var imdbID: String
}

struct MovieDetail: Decodable {
    var Actors: String
    var Director: String
    var Writer: String
    var Plot: String
    var Genre: String
    var imdbRating: String
    var Runtime: String
    var Released: String
    var Language: String
}
