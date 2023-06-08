//
//  MovieGroupViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/07.
//

import UIKit
import SwiftCSV

class MovieGroupViewController: UIViewController {
    
    @IBOutlet weak var movieGroupTableView: UITableView!
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieGroupTableView.dataSource = self
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
                if let title = row["title"], let voteCountString = row["vote_count"], let vote_count = Int(voteCountString) {
                    let movie = Movie(title: title, vote_count: vote_count)
                    sortedMovies.append(movie)
                }
            }
            
            sortedMovies.sort(by: { $0.vote_count > $1.vote_count })
            
            movies = Array(sortedMovies.prefix(100))
            
            self.movieGroupTableView.reloadData()
            
        } catch {
            print("Error reading CSV file")
        }
    }
}

extension MovieGroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGroupViewCell", for: indexPath)
        let movie = movies[indexPath.row]
//        cell.textLabel!.text = "Title: \(movie.title), Vote Count: \(movie.vote_count)"
        cell.textLabel!.text = "\(movie.title)"
        return cell
    }
}


