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
        view.tableView.prefetchDataSource = self
        return view
    }()
    
    var mainViewModel: MainViewModelProtocol! {
        didSet {
            mainViewModel.delegate = self
        }
    }
    
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        navigationItem.title = "Main Page"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = mainView.searchBar
        setupBindings()
        mainViewModel.getPopularMovies()
    }
}

extension MainViewController {
    
    func setupBindings() {

        mainView.searchBar.rx.text
                    .orEmpty
                    .throttle(.seconds(1), scheduler: MainScheduler.instance)
                    .distinctUntilChanged()
                    .subscribe(onNext: { [weak self] query in
                        self?.mainViewModel.searchMovieAndPerson(searchQuery: query)
                    })
                    .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.numberOfRowsInSection(for: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfig(withViewModel: mainViewModel.createCellViewModel(for: indexPath))
        return cell
    }
}

extension MainViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {

    }
}

extension MainViewController: MainViewModelDelegate {
    
    func reloadTableViewData() {
        mainView.tableView.reloadData()
    }
    
    func startLoading() {
        mainView.tableView.loadingView(true)
    }
    
    func stopLoading() {
        mainView.tableView.loadingView(false)
    }
    
    
}
