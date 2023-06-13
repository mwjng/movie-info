//
//  ReviewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/14.
//

import Foundation
import UIKit

class RatingViewController: UIViewController {
    var rating: Int = 0
    var starButtons: [UIButton] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stars()
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
            starButton.addTarget(self, action: #selector(starButtonTapped(_:)), for: .touchUpInside)
            starButtons.append(starButton)
            view.addSubview(starButton)
        }
    }
    
    @objc func starButtonTapped(_ sender: UIButton) {
        let selectedStars = sender.tag + 1
        updateRating(selectedStars)
    }
    
    func updateRating(_ stars: Int) {
        for (index, starButton) in starButtons.enumerated() {
            starButton.isSelected = index < stars
        }
        rating = stars
    }
}

