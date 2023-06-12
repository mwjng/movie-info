//
//  SearchViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/10.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var dbMemory = DbMemory.shared
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        movies = dbMemory.queryMoviesByTitle(title: searchText) ?? []
        
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResult", for: indexPath) as? SearchResult
        let movie = movies[indexPath.row]
        cell!.titleLabel.text = movie.title
        cell!.idLabel!.text = String(movie.id)
        cell!.overviewLabel!.text = movie.overview
        cell!.overviewLabel.numberOfLines = 0
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.row]
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.movie = selectedMovie
            navigationController?.show(detailVC, sender: self)
        }
    }

}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

class SearchResult: UITableViewCell {
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
}
