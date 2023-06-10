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
        
        // 메인 화면과 검색 화면을 나타내는 뷰 컨트롤러 생성
        let movieGroupViewController = MovieGroupViewController()
        //let searchViewController = SearchViewController()
        
        // 메인 화면과 검색 화면을 탭 바의 뷰 컨트롤러로 설정
        self.viewControllers = [movieGroupViewController]
        
        // 탭 바 외관 커스터마이징 (예: 선택된 탭의 색상 변경)
        self.tabBar.tintColor = UIColor.red
    }
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            
            // 처음 로딩될 때 MovieGroupViewController 선택
            self.selectedIndex = 0
    }
}
