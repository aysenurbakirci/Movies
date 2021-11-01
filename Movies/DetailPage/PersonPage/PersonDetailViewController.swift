//
//  PersonDetailViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit
import RxSwift
import Utils
import Components

class PersonDetailViewController: UIViewController, LoadingDisplay {

    private lazy var detailView: DetailView = {
        var view = DetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    lazy var header = StrechyHeader(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 1.5))
    
    var viewModel: PersonDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        navigationBarConfig()
        detailView.tableView.tableHeaderView = header
        
        viewModel
            .data
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.detailView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel
            .isLoading
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showLoadingView()
                } else {
                    self.hideLoadingView()
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.getDetails()
    }
    
    private func navigationBarConfig() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension PersonDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.data.value[indexPath.section]
        
        switch section {
        case .detail(let personDetail):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier, for: indexPath) as? InformationCell else {
                return UITableViewCell()
            }
            
            cell.apply(personDetail: personDetail)
            header.apply(imagePath: personDetail.profilePath ?? "")
            
            return cell
            
        case .list(let personMovies):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier, for: indexPath) as? ListCell else {
                return UITableViewCell()
            }
            
            let listModel = ListModel(personMovies: personMovies)
            cell.horizontalListView.dataArrayRelay.accept(listModel.castArray)
            cell.horizontalListView
                .selectedItemId
                .subscribe(onNext: { [weak self] id in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(self.viewModel.openMoviePage(id: id), animated: true)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

extension PersonDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = detailView.tableView.tableHeaderView as? StrechyHeader else { return }
        header.scrollViewDidScroll(scrollView: detailView.tableView)
    }
}
