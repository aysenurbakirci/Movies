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
        mainViewModel.loadData.onNext(())
    }
}

extension MainViewController {
    
    func setupBindings() {
        
        mainViewModel
            .data
            .subscribe(onNext: { [weak self] _ in
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        mainViewModel
            .isLoading
            .subscribe(onNext: { [weak self] isLoading in
                self?.mainView.tableView.loadingView(isLoading)
            })
            .disposed(by: disposeBag)

        mainView.searchBar.rx.text
            .bind(to: mainViewModel.searchQuery)
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainViewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainViewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfig(withViewModel: mainViewModel.createCellViewModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if mainView.searchBar.text?.isEmpty ?? true {
            let totalCount = mainViewModel.data.value.first { section in
                if case .movie = section {
                    return true
                }
                return false
            }?.numberOfItems ?? 0
            
            if indexPath.row == (totalCount - 1) {
                mainViewModel.loadData.onNext(())
            }
        }
    }
}
