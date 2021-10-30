//
//  MovieDetailViewContoller.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieDetailViewController: UIViewController, LoadingDisplay {
    
    private lazy var movieDetailView: MovieDetailView = {
        var view = MovieDetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    lazy var header = StrechyHeaderView(frame: .init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width * 0.5))
    
    var viewModel: MovieDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieDetailView.tableView.tableHeaderView = header
        
        view = movieDetailView
        
        viewModel
            .data
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.movieDetailView.tableView.reloadData()
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
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = viewModel.data.value[indexPath.section]
        
        switch section {
        case .detail(let movieDetail):

            guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieInformationCell.reuseIdentifier, for: indexPath) as? MovieInformationCell else {
                return UITableViewCell()
            }
            
            cell.apply(detailModel: movieDetail)
            cell.linkButton
                .rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let key = movieDetail.trailers.first?.key, let self = self else { return }
                    self.viewModel.openLink(key: key)
                })
                .disposed(by: cell.disposeBag)
            
            header.apply(imagePath: movieDetail.backdropPath ?? "")
//            
//            cell.imageIsLoad
//                .subscribe(onNext: {
//                    tableView.reloadRows(at: [indexPath], with: .automatic)
//                })
//                .disposed(by: cell.disposeBag)
            
            return cell
            
        case .list(let movieCastList):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonListCell.reuseIdentifier, for: indexPath) as? PersonListCell else {
                return UITableViewCell()
            }
            
            let listModel = ListModel(movieCast: movieCastList)
            cell.horizontalListView.dataArrayRelay.accept(listModel.castArray)
            cell.horizontalListView
                .selectedItemId
                .subscribe(onNext: { [weak self] id in
                    guard let self = self else { return }
                    self.navigationController?.pushViewController(self.viewModel.openPersonPage(id: id), animated: true)
                })
                .disposed(by: cell.disposeBag)
            
            return cell
        }
    }
}

extension MovieDetailViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = movieDetailView.tableView.tableHeaderView as? StrechyHeaderView else { return }
        header.scrollViewDidScroll(scrollView: movieDetailView.tableView)
    }
}
