//
//  MainViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 11.10.2021.
//

import UIKit
import RxSwift
import Utils

class MainViewController: UIViewController, ActivityDisplayer {
    
    var bag: DisposeBag = DisposeBag()
    
    private lazy var mainView: MainView = {
        var view = MainView()
        view.tableView.dataSource = self
        view.tableView.delegate = self
        return view
    }()
    
    var viewModel = MainViewModel(mainViewService: MainApi())
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = mainView
        navigationBarConfig()
        setupBindings()
        viewModel.loadData.onNext(())
        bindLoading()
        bindEmptyView()
        bindErrorHandling()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func navigationBarConfig() {
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Main Page"
        navigationItem.titleView = mainView.searchBar
    }
}

extension MainViewController {
    
    func setupBindings() {
        
        viewModel
            .data
            .subscribe(onNext: { [weak self] _ in
                self?.mainView.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        mainView.searchBar.rx.text
            .bind(to: viewModel.searchQuery)
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.reuseIdentifier, for: indexPath) as? MainTableViewCell else {
            return UITableViewCell()
        }
        cell.cellConfig(withViewModel: viewModel.createCellViewModel(for: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if mainView.searchBar.text?.isEmpty ?? true {
            let totalCount = viewModel.data.value.first { section in
                if case .movie = section {
                    return true
                }
                return false
            }?.numberOfItems ?? 0
            
            if indexPath.row == (totalCount - 1) {
                viewModel.loadData.onNext(())
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(viewModel.openDetailPage(for: indexPath), animated: true)
    }
}
