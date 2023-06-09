//
//  movie.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/08.
//

import Foundation

class Movie {
    var title: String
    var vote_count: Int
    var vote_average: Double
    var genres: [String]?
    
    init(title: String, vote_count: Int, vote_average: Double, genres: [String]?) {
        self.title = title
        self.vote_count = vote_count
        self.vote_average = vote_average
        self.genres = genres
    }
}
