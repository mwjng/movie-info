//
//  SearchViewController.swift
//  ott_movies
//
//  Created by mwjng on 2023/06/10.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        // 사용자가 검색 버튼을 클릭했을 때 실행될 코드
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            return
        }
        
        // 영화 검색 로직을 수행하고 결과를 movies 배열에 저장하는 코드를 작성합니다.
        // 예를 들어, API를 통해 영화 검색을 수행하거나 로컬 데이터베이스에서 검색 결과를 가져오는 등의 작업을 수행합니다.
        
        // 임시로 더미 데이터를 생성하여 결과를 보여주는 예시
        movies = createDummyMovies(searchText: searchText)
        
        tableView.reloadData()
    }
    
    // 임시로 더미 데이터를 생성하는 메소드
    func createDummyMovies(searchText: String) -> [Movie] {
        var movies: [Movie] = []
        for i in 1...5 {
            let movie = Movie(title: "\(searchText) Movie \(i)", vote_count: 10, vote_average: 9.0, genres: ["Action"])
            movies.append(movie)
        }
        return movies
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = movies[indexPath.row]
        cell.textLabel?.text = movie.title
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 사용자가 특정 영화를 선택했을 때 실행될 코드
        let selectedMovie = movies[indexPath.row]
        // 선택된 영화에 대한 추가 동작을 수행할 수 있습니다.
        print("Selected Movie: \(selectedMovie.title)")
    }
}

