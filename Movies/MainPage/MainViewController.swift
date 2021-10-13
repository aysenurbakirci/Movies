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
    
    var mainViewModel: MainViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        navigationItem.title = "Main Page"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = mainView.searchBar
        setupBindings()
        mainViewModel.getPopularMovies(page: 1)
    }
}

extension MainViewController {
    
    func setupBindings() {
        mainViewModel
            .data
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {[weak self] data in
                guard let self = self else { return }
                self.mainView.tableView.reloadData()
            }).disposed(by: disposeBag)
        
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
        return mainViewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.data.value[section].numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfig(withViewModel: mainViewModel.createCellViewModel(for: indexPath))
        return cell
    }
}
