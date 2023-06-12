//
//  DetailViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/11.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var etcLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let movie = movie {
            if let releaseDate = movie.release_date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let yearString = dateFormatter.string(from: releaseDate)
                titleLabel.text = "\(movie.title) (\(yearString))"
            } else {
                titleLabel.text = movie.title
            }
            
            if let releaseDate = movie.release_date {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let dateString = dateFormatter.string(from: releaseDate)
                etcLabel.text = "\(dateString) | "
                    
            } else {
                etcLabel.text = ""
            }
            
            let genresString = movie.genres.joined(separator: ", ")
            genreLabel.text = genresString
            scoreLabel.text = String(movie.vote_average)
            
            let companyString = movie.production_companies.joined(separator: ", ")
            companyLabel.text = companyString
            
            overviewLabel.text = movie.overview
            overviewLabel.numberOfLines = 0
        }



    }
}
