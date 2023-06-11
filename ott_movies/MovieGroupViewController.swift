//
//  MovieGroupViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/07.
//

import UIKit

class MovieGroupViewController: UIViewController {
    
    @IBOutlet weak var movieGroupTableView: UITableView!
    var movieGroups: [[Movie]] = []
    var dbMemory = DbMemory.shared
    let genres: [String] = ["Action", "Drama", "Comedy", "Thriller", "Adventure"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queryGenres()
        
        movieGroupTableView.dataSource = self
        movieGroupTableView.delegate = self
        
    }
    
    func queryGenres() {
        for genre in genres {
            let movies = dbMemory.queryMoviesByGenre(genre: genre)
            movieGroups.append(movies)
        }
        
        movieGroupTableView.reloadData()
    }
}

extension MovieGroupViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return movieGroups.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenreTableViewCell", for: indexPath) as? GenreTableViewCell else {
            return UITableViewCell()
        }
        
        cell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.section)
        cell.textLabel!.text = genres[indexPath.section]
        
        return cell
    }
}

extension MovieGroupViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let movies = movieGroups[collectionView.tag]
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGroupViewCell", for: indexPath) as! MovieGroupViewCell
        let movies = movieGroups[collectionView.tag]
        let movie = movies[indexPath.item]
        cell.movieGenreView?.text = movie.title
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width * 0.7
        let height = collectionView.bounds.height
        return CGSize(width: width, height: height)
    }
}

class GenreTableViewCell: UITableViewCell {
    
    @IBOutlet weak var genreCollectionView: UICollectionView!
    
    var row: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        genreCollectionView.collectionViewLayout = layout
        
        genreCollectionView.showsHorizontalScrollIndicator = false
        
    }
    
    func setCollectionViewDataSourceDelegate(dataSourceDelegate: UICollectionViewDataSource & UICollectionViewDelegateFlowLayout, forRow row: Int) {
        self.row = row
        genreCollectionView.dataSource = dataSourceDelegate
        genreCollectionView.delegate = dataSourceDelegate
        genreCollectionView.tag = row
        genreCollectionView.reloadData()
    }
}

class MovieGroupViewCell: UICollectionViewCell {
    @IBOutlet weak var movieGenreView: UILabel!
}
