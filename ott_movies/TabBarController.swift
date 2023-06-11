//
//  TabBarController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/10.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let movieGroupViewController = MovieGroupViewController()
        
        let searchViewController = SearchViewController()
        
        self.viewControllers = [movieGroupViewController, searchViewController]
    }
}

