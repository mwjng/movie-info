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
    
    init(title: String, vote_count: Int) {
        self.title = title
        self.vote_count = vote_count
    }
}
