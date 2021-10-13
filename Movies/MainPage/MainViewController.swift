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
    
    private var movieList: [Movie] = []
    var mainViewModel: MainViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        navigationItem.title = "Main Page"
        navigationController?.navigationBar.prefersLargeTitles = true
        setupBindings()
        mainViewModel.getPopularMovies()
    }
}

extension MainViewController {
    
    func setupBindings() {
        mainViewModel
            .popularMoviesRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                self.movieList = data
                self.mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
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
                let cellViewModel = MovieCellViewModel(movie: movie)
                
                cell.cellConfig(withViewModel: cellViewModel)
                
                return cell
            }
            return cell
        }
        return UITableViewCell()
    }
}
