//
//  ReviewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/14.
//

import Foundation
import UIKit

class RatingViewController: UIViewController {
    @IBOutlet weak var msgLabel: UILabel!
    @IBOutlet weak var ratingNavi: UINavigationItem!
    var id: String?
    var rating: Int = 0
    var starButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stars()
        setupRightBar()
    }
    
    func stars() {
        let starSize: CGFloat = 30
        let spacing: CGFloat = 10
        let starCount: Int = 5
        
        for i in 0..<starCount {
            let starButton = UIButton()
            starButton.frame = CGRect(x: CGFloat(i) * (starSize + spacing) + 100, y: 200, width: starSize, height: starSize)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
            starButton.tag = i
            starButton.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starButtons.append(starButton)
            view.addSubview(starButton)
        }
    }
    
    func setupRightBar() {
        let rightBarButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(confirmTapped))
        ratingNavi.rightBarButtonItem = rightBarButton
    }
    
    @objc func starTapped(_ sender: UIButton) {
        let selectedStars = sender.tag + 1
        updateRating(selectedStars)
        updateMessage(selectedStars)
    }
    
    func updateRating(_ stars: Int) {
        for (index, starButton) in starButtons.enumerated() {
            starButton.isSelected = index < stars
        }
        rating = stars
    }
    
    func updateMessage(_ stars: Int) {
        switch stars {
        case 1:
            msgLabel.text = "Very Poor..."
        case 2:
            msgLabel.text = "Poor.."
        case 3:
            msgLabel.text = "Average"
        case 4:
            msgLabel.text = "Good!"
        case 5:
            msgLabel.text = "Excellent!!"
        default:
            msgLabel.text = ""
        }
    }
    
    @objc func confirmTapped() {
        let alertController = UIAlertController(title: "Star Rating", message: "Score : \(rating*2)", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.sendRating()
        }
        let cancelAction = UIAlertAction(title: "No", style: .default)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func sendRating() {
        guard let id = self.id else {
            print("No id")
            return
        }
        
        let parameters: [String: Any] = [
            "value": self.rating
        ]
        
        let headers = [
          "accept": "application/json",
          "Content-Type": "application/json;charset=utf-8",
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://api.themoviedb.org/3/movie/\(id)/rating")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = jsonData
        } catch {
            print(error)
            return
        }

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
              print(error as Any)
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Fail", message: error?.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse!)
              if (200...299).contains(httpResponse!.statusCode) {
                  DispatchQueue.main.async {
                      let alertController = UIAlertController(title: "Success", message: "Rating is registered.", preferredStyle: .alert)
                      let confirmAction = UIAlertAction(title: "Ok", style: .default) { _ in
                          self.dismiss(animated: true, completion: nil)
                          self.navigationController?.popViewController(animated: true)
                      }
                      alertController.addAction(confirmAction)
                      self.present(alertController, animated: true, completion: nil)
                  }
              }
              else {
                  DispatchQueue.main.async {
                      let alert = UIAlertController(title: "Fail", message: "Failed to send", preferredStyle: .alert)
                      alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                      self.present(alert, animated: true, completion: nil)
                  }
              }
          }
        })

        dataTask.resume()
    }
}
