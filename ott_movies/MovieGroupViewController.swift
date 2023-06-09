//
//  MovieGroupViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/07.
//

import UIKit

class MovieGroupViewController: UIViewController {
    
    @IBOutlet weak var movieGroupTableView: UITableView!
    var movies: [Movie] = []
    var dbMemory: DbMemory!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movieGroupTableView.dataSource = self
        dbMemory = DbMemory(parentNotification: nil)
        queryGenre(genre: "Action")
    }
    
    func queryGenre(genre: String) {
        movies = dbMemory.queryMoviesByGenre(genre: genre)
        movieGroupTableView.reloadData()
    }
}

extension MovieGroupViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieGroupViewCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel!.text = "\(movie.title)"
        return cell
    }
}
