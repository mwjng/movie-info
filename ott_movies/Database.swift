//
//  Database.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/09.
//

import Foundation

enum DbAction{
    case Add, Delete, Modify
}

protocol Database {
    init(parentNotification: ((Movie?, DbAction) -> Void)?)
    
    func queryMovie(count: Int)
    func saveChange(movie: Movie, action: DbAction)
}
