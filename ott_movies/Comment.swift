//
//  Comment.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/13.
//

import Foundation

class Comment {
    var author: String
    var content: String
    var created_at: String
    var rating: String
    
    init(author: String, content: String, created_at: String, rating: String) {
        self.author = author
        self.content = content
        self.created_at = created_at
        self.rating = rating
    }
}
