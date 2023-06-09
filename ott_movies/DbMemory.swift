//
//  DbMemory.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/09.
//
import UIKit
import SwiftCSV

class DbMemory: Database {
    private var storage: [Movie] = []
    private var parentNotification: ((Movie?, DbAction) -> Void)?
    
    required init(parentNotification: ((Movie?, DbAction) -> Void)?) {
        self.parentNotification = parentNotification
        loadMovies()
    }
    
    private func loadMovies() {
        guard let url = Bundle.main.url(forResource: "movies_metadata", withExtension: "csv")
        else {
            print("CSV file not found")
            return
        }

            
        do {
            let csv = try CSV<Named>(url: url)
            let rows = csv.rows
            
            var sortedMovies: [Movie] = []
                        
            for row in rows {
                if let title = row["title"],
                   let voteCountString = row["vote_count"],
                   let vote_count = Int(voteCountString),
                   let voteAverageString = row["vote_average"],
                   let vote_average = Double(voteAverageString) {
                                       
                    if var genreString = row["genres"] {
                        genreString = genreString.replacingOccurrences(of: "'", with: "\"")

                        if let jsonData = genreString.data(using: .utf8) {
                            do {
                                if let jsonArray = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [[String: Any]] {
                                    var genreNames: [String] = []
                                    
                                    for jsonObject in jsonArray {
                                        if let name = jsonObject["name"] as? String {
                                            genreNames.append(name)
                                        }
                                    }
                                    
                                    let movie = Movie(title: title, vote_count: vote_count, vote_average: vote_average, genres: genreNames)
                                    sortedMovies.append(movie)
                                }
                            } catch {
                                print("Error parsing JSON data")
                            }
                        }
                    }
                }
            }
            
            sortedMovies.sort(by: { $0.vote_count > $1.vote_count })
            storage = Array(sortedMovies.prefix(100))
            
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
    
    func queryMoviesByGenre(genre: String) -> [Movie] {
        let filteredMovies = storage.filter { movie in
            return movie.genres.contains(genre)
        }

        let sortedMovies = filteredMovies.sorted { $0.vote_count > $1.vote_count }
        let top20Movies = Array(sortedMovies.prefix(20))
        return top20Movies
    }

}
