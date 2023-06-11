//
//  DbMemory.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/09.
//
import UIKit
import SwiftCSV

class DbMemory: Database {
    static let shared = DbMemory()
    private var storage: [Movie] = []
    private var parentNotification: ((Movie?, DbAction) -> Void)?
    
    private init() {
            loadMovies()
    }
    
    private func loadMovies() {
        guard let url = Bundle.main.url(forResource: "movies_metadata", withExtension: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let csv = try CSV<Named>(url: url)
            let rows = csv.rows
            
            var sortedMovies: [Movie] = []
            
            for row in rows {
                if let title = row["title"],
                   let idString = row["id"],
                   let id = Int(idString),
                   let original_language = row["original_language"],
                   let original_title = row["original_title"],
                   let popularityString = row["popularity"],
                   let popularity = Double(popularityString),
                   let voteCountString = row["vote_count"],
                   let vote_count = Int(voteCountString),
                   let voteAverageString = row["vote_average"],
                   let vote_average = Double(voteAverageString) {
                    
                    let budget = Int(row["budget"] ?? "")
                    let homepage = row["homepage"]
                    let imdb_id = row["imdb_id"]
                    let overview = row["overview"]
                    let poster_path = row["poster_path"]
                    let revenue = Int(row["revenue"] ?? "")
                    let runtime = Double(row["runtime"] ?? "")
                    let status = row["status"]
                    let tagline = row["tagline"]
                    
                    var genres: [String] = []
                    if var genreString = row["genres"] {
                        genreString = genreString.replacingOccurrences(of: "'", with: "\"")
                        if let jsonData = genreString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    for jsonObject in jsonArray {
                                        if let name = jsonObject["name"] as? String {
                                            genres.append(name)
                                        }
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    let releaseDateString = row["release_date"]
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    let releaseDate = dateFormatter.date(from: releaseDateString ?? "")

                    var spoken_languages: [String] = []
                    if var spokenLanguagesString = row["spoken_languages"] {
                        spokenLanguagesString = spokenLanguagesString.replacingOccurrences(of: "'", with: "\"")
                        if let jsonData = spokenLanguagesString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    for jsonObject in jsonArray {
                                        if let name = jsonObject["name"] as? String {
                                            spoken_languages.append(name)
                                        }
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    var production_companies: [String] = []
                    if var productionCompaniesString = row["production_companies"] {
                        productionCompaniesString = productionCompaniesString.replacingOccurrences(of: "'", with: "\"")
                        if let jsonData = productionCompaniesString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    for jsonObject in jsonArray {
                                        if let name = jsonObject["name"] as? String {
                                            production_companies.append(name)
                                        }
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    var production_countries: [String] = []
                    if var productionCountriesString = row["production_countries"] {
                        productionCountriesString = productionCountriesString.replacingOccurrences(of: "'", with: "\"")
                        if let jsonData = productionCountriesString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    for jsonObject in jsonArray {
                                        if let name = jsonObject["name"] as? String {
                                            production_countries.append(name)
                                        }
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                    let movie = Movie(budget: budget, genres: genres, homepage: homepage, id: id, imdb_id: imdb_id, original_language: original_language, original_title: original_title, overview: overview, popularity: popularity, poster_path: poster_path, production_companies: production_companies, production_countries: production_countries, release_date: releaseDate, revenue: revenue, runtime: runtime, spoken_languages: spoken_languages, status: status, tagline: tagline, title: title, vote_average: vote_average, vote_count: vote_count)
                    
                    sortedMovies.append(movie)
                }
            }
            
            sortedMovies.sort(by: { $0.vote_count > $1.vote_count })
            storage = Array(sortedMovies.prefix(100))
            
//            print("Title: \(storage[0].title)")
//            print("Budget: \(storage[0].budget ?? 0)")
//            print("Genres: \(storage[0].genres)")
//            print("Homepage: \(storage[0].homepage ?? "")")
//            print("ID: \(storage[0].id)")
//            print("IMDb ID: \(storage[0].imdb_id ?? "")")
//            print("Original Language: \(storage[0].original_language)")
//            print("Original Title: \(storage[0].original_title)")
//            print("Overview: \(storage[0].overview ?? "")")
//            print("Popularity: \(storage[0].popularity)")
//            print("Poster Path: \(storage[0].poster_path ?? "")")
//            print("Production Companies: \(storage[0].production_companies)")
//            print("Production Countries: \(storage[0].production_countries)")
//            print("Release Date: \(storage[0].release_date ?? Date())")
//            print("Revenue: \(storage[0].revenue ?? 0)")
//            print("Runtime: \(storage[0].runtime ?? 0)")
//            print("Spoken Languages: \(storage[0].spoken_languages)")
//            print("Status: \(storage[0].status ?? "")")
//            print("Tagline: \(storage[0].tagline ?? "")")
//            print("Vote Average: \(storage[0].vote_average)")
//            print("Vote Count: \(storage[0].vote_count)")
            
        } catch {
            print("Error reading CSV file")
        }
    }

    func queryMovie(count: Int) {
        let queriedMovies = Array(storage.prefix(count))
        for movie in queriedMovies {
            parentNotification?(movie, .Add)
        }
    }
    
    func saveChange(movie: Movie, action: DbAction) {
            
    }
    
    func queryMoviesByTitle(title: String) -> [Movie]? {
        let filteredMovies = storage.filter { movie in
            guard let range = movie.title.range(of: title, options: .caseInsensitive) else {
                return false
            }
            return !range.isEmpty
        }
        
        let sortedMovies = filteredMovies.sorted { $0.vote_average > $1.vote_average }
        let findMovies = Array(sortedMovies.prefix(100))
        return findMovies.isEmpty ? nil : findMovies
    }

    func queryMoviesByGenre(genre: String) -> [Movie] {
        let filteredMovies = storage.filter { movie in
            return movie.genres.contains(genre)
        }

        let sortedMovies = filteredMovies.sorted { $0.popularity > $1.popularity }
        let top20Movies = Array(sortedMovies.prefix(20))
        return top20Movies
    }
}
