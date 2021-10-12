//
//  MainViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import UIKit
import RxSwift

class MainViewController: UIViewController {
    
    private lazy var mainView: MainView = {
        var view = MainView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    private lazy var movieList: [Movie] = []
    private lazy var mainViewModel = MainViewModel()
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        navigationItem.title = "Main Page"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPopularMovies()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell {

            if movieList.count > 0 {
                
                let movie = movieList[indexPath.row]
                let imageInfo = ImageInfo(urlString: movie.posterPath, width: 500)
                let title = TextConfiguration(title: movie.title, titleFont: nil, titleColor: nil)
                let releaseDate = TextConfiguration(title: movie.releaseDate, titleFont: nil, titleColor: nil)
                let averageVote = TextConfiguration(title: String(movie.voteAverage), titleFont: nil, titleColor: nil)
                cell.cellConfiguration(imageInfo: imageInfo, title: title, subtitle: releaseDate, secondSubtitle: averageVote)
                
                return cell
            }
            return cell
        }
        return UITableViewCell()
    }
    
}

extension MainViewController {
    func getPopularMovies() {
        mainViewModel.getPopularMovies()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] movies in
                guard let self = self else { return }
                self.movieList = movies
                self.mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
}
