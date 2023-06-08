//
//  movie.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/08.
//

import Foundation

class MovieDetail: NSObject {
    var budget: Int?
    var genres: [String]?
    var homepage: String?
    var id: Int
    var imdb_id: String?
    var original_language: String
    var original_title: String
    var overview: String?
    var popularity: Double
    var poster_path: String?
    var production_companies: [String]
    var production_countries: [String]
    var release_date: Date?
    var revenue: Int?
    var runtime: Double?
    var spoken_languages: [String]
    var status: String?
    var tagline: String?
    var title: String
    var video: Bool
    var vote_average: Double
    var vote_count: Int

    init(budget: Int?, genres: [String]?, homepage: String?, id: Int, imdb_id: String?, original_language: String, original_title: String, overview: String?, popularity: Double, poster_path: String?, production_companies: [String], production_countries: [String], release_date: Date?, revenue: Int?, runtime: Double?, spoken_languages: [String], status: String?, tagline: String?, title: String, video: Bool, vote_average: Double, vote_count: Int) {
        self.budget = budget
        self.genres = genres
        self.homepage = homepage
        self.id = id
        self.imdb_id = imdb_id
        self.original_language = original_language
        self.original_title = original_title
        self.overview = overview
        self.popularity = popularity
        self.poster_path = poster_path
        self.production_companies = production_companies
        self.production_countries = production_countries
        self.release_date = release_date
        self.revenue = revenue
        self.runtime = runtime
        self.spoken_languages = spoken_languages
        self.status = status
        self.tagline = tagline
        self.title = title
        self.video = video
        self.vote_average = vote_average
        self.vote_count = vote_count
        super.init()
    }
}
