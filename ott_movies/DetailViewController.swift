//
//  DetailViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/11.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var etcLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var recommendCollectionView: UICollectionView!
    @IBOutlet weak var commentTableView: UITableView!
    var movie: Movie?
    var comments: [Comment] = []
    var recommendAll: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.dataSource = self
        recommendCollectionView.dataSource = self
        recommendCollectionView.delegate = self
        
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
                if let runtime = movie.runtime {
                    let runtimeString = String(Int(runtime))
                    etcLabel.text = "\(dateString)  |  \(runtimeString)m"
                }
                else {
                    etcLabel.text = ""
                }
                
            } else {
                etcLabel.text = ""
            }
            etcLabel.numberOfLines = 0
            let genresString = movie.genres.joined(separator: ", ")
            genreLabel.text = genresString
            genreLabel.numberOfLines = 0
            scoreLabel.text = String(movie.vote_average)
            
            let companyString = movie.production_companies.joined(separator: ", ")
            companyLabel.text = companyString
            companyLabel.numberOfLines = 0
            overviewLabel.text = movie.overview
            overviewLabel.numberOfLines = 0
        }
        recommendAll = recommendMovies()
        naviItem.title = movie?.title
        getReviews()
        setupRightBar()
    }
    
    func getReviews() {
        let apiKey = ""
                
        if let movieId = movie?.id {
            let movieIdString = String(movieId)
            var urlStr = "https://api.themoviedb.org/3/movie/\(movieIdString)/reviews?api_key=\(apiKey)"
            urlStr = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let session = URLSession(configuration: .default)
            let url = URL(string: urlStr)
            let request = URLRequest(url: url!)
            
            let dataTask = session.dataTask(with: request) {
                (data, response, error) in
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        if let results = json?["results"] as? [[String: Any]] {
                            for result in results {
                                let content = result["content"]
                                let author = result["author"]
                                if let author_details = result["author_details"] as? [String: Any],
                                   let rating = author_details["rating"] as? Int {
                                    let ratingString = String(rating)
                                    let created = result["created_at"] as? String
                                    let createdArray = created?.components(separatedBy: "T")
                                    let created_at = createdArray?[0]
                                    self.comments.append(Comment(author: author! as! String, content: content! as! String, created_at: created_at!, rating: ratingString))
                                } else {
                                    print("---------")
                                }
                            }
                            self.comments = self.comments.sorted { $0.created_at > $1.created_at }
                        }

                        DispatchQueue.main.async {
                            self.commentTableView.reloadData() // 테이블뷰 데이터 리로드
                        }
                    } catch {
                        print("error parsing")
                    }
                }
            }
            
            dataTask.resume()
        }
        
    }
    
    func setupRightBar() {
        let rightBarButton = UIBarButtonItem(title: "Add Rating", style: .plain, target: self, action: #selector(ratingTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }

    @objc func ratingTapped() {
        if let movieId = movie?.id {
            let ratingViewController = storyboard?.instantiateViewController(withIdentifier: "RatingViewController") as! RatingViewController
            ratingViewController.id = String(movieId)
            navigationController?.show(ratingViewController, sender: self)
        }
    }
    
    func recommendMovies() -> [String] {
        var similarMovies = DbMemory.shared.queryAllMoviesByGenre(genres: movie!.genres)
        similarMovies.removeAll { $0.title == movie?.title }

        let sortedMovies = similarMovies.sorted{(movie1, movie2) -> Bool in
            let similarity1 = cosineSimilarity(movie!.overview, movie1.overview)
            let similarity2 = cosineSimilarity(movie!.overview, movie2.overview)
            return similarity1 > similarity2
        }
        let recommendMovies = Array(sortedMovies.prefix(10)).map { $0.title }
        return recommendMovies
    }
    
    func cosineSimilarity(_ string1: String, _ string2: String) -> Double {
        let string1Vector = stringToVector(string1)
        let string2Vector = stringToVector(string2)
        
        let dotProduct = calculateDotProduct(string1Vector, string2Vector)
        let magnitudeProduct = calculateMagnitude(string1Vector) * calculateMagnitude(string2Vector)
        
        return dotProduct / magnitudeProduct
    }

    private func stringToVector(_ string: String) -> [Double] {
        var vector: [Double] = Array(repeating: 0.0, count: 26)
        for character in string.lowercased() {
            if let asciiValue = character.asciiValue {
                let index = Int(asciiValue) - Int(UnicodeScalar("a").value)
                if index >= 0 && index < 26 {
                    vector[index] += 1.0
                }
            }
        }
        return vector
    }

    private func calculateDotProduct(_ vector1: [Double], _ vector2: [Double]) -> Double {
        var dotProduct: Double = 0.0
        for i in 0..<vector1.count {
            dotProduct += vector1[i] * vector2[i]
        }
        return dotProduct
    }

    private func calculateMagnitude(_ vector: [Double]) -> Double {
        var sumOfSquares: Double = 0.0
        for value in vector {
            sumOfSquares += value * value
        }
        return sqrt(sumOfSquares)
    }
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell
        let comment = comments[indexPath.row]
        cell!.authorLabel.text = comment.author
        cell!.authorLabel.numberOfLines = 1
        cell!.dateLabel.text = comment.created_at
        cell!.ratingLabel.text = comment.rating
        cell!.reviewLabel.text = comment.content
        cell!.reviewLabel.numberOfLines = 0
        return cell!
    }
}

extension DetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendAll.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CollectionViewCell
        let movie = recommendAll[indexPath.row]
        cell!.recommendLabel.text = movie
        cell!.posterImg.frame = CGRect(x: 0.0, y: 8, width: 100, height: 100)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width - 300
        let cellHeight = collectionView.bounds.height
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = recommendAll[indexPath.item]
        let movieDetail = DbMemory.shared.queryMovieByTitle(title: selectedMovie)
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            detailVC.movie = movieDetail
            navigationController?.show(detailVC, sender: self)
        }
    }
}

class CommentTableViewCell: UITableViewCell{
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    override func layoutSubviews() {
        super.layoutSubviews()
        let topLine = CALayer()
        topLine.frame = CGRect(x: 0, y: 0, width: contentView.frame.width, height: 1)
        topLine.backgroundColor = UIColor.lightGray.cgColor
        contentView.layer.addSublayer(topLine)
    }
}

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImg: UIImageView!
    @IBOutlet weak var recommendLabel: UILabel!
}
