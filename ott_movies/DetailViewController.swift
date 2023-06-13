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
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commentTableView.dataSource = self
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
        
        getReviews()
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
        let labelHeight = cell!.reviewLabel.sizeThatFits(CGSize(width: cell!.reviewLabel.frame.width, height: CGFloat.greatestFiniteMagnitude)).height
        cell!.reviewLabel.frame.size.height = labelHeight
        return cell!
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

        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: contentView.frame.height - 1, width: contentView.frame.width, height: 1)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        contentView.layer.addSublayer(bottomLine)
    }
}
