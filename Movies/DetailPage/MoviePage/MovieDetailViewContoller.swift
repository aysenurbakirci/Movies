//
//  MovieDetailViewContoller.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import UIKit
import RxSwift
import RxCocoa
import Components
import Utils

class MovieDetailViewController: UIViewController, LoadingDisplay {
    
    
    lazy var header = StrechyHeader(frame: .init(x: 0,
                                                 y: 0,
                                                 width: view.frame.size.width,
                                                 height: view.frame.size.width * 0.4))
    
    private lazy var detailView: DetailView = {
        var view = DetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        view.tableView.tableHeaderView = header
        return view
    }()
    
    var viewModel: MovieDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        clearNavigationBarConfig()
        
        viewModel
            .data
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.detailView.tableView.reloadData()
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
    
    private func clearNavigationBarConfig() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
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

            guard let cell = tableView.dequeueReusableCell(withIdentifier: InformationCell.reuseIdentifier,
                                                           for: indexPath) as? InformationCell else {
                return UITableViewCell()
            }
            
            cell.apply(movieDetail: movieDetail)
            cell.linkButton
                .rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let key = movieDetail.trailers.first?.key, let self = self else { return }
                    self.viewModel.openLink(key: key)
                })
                .disposed(by: cell.disposeBag)
            
            header.apply(imagePath: movieDetail.backdropPath ?? "")
            
            return cell
            
        case .list(let movieCastList):
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ListCell.reuseIdentifier,
                                                           for: indexPath) as? ListCell else {
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
        guard let header = detailView.tableView.tableHeaderView as? StrechyHeader else { return }
        header.scrollViewDidScroll(scrollView: detailView.tableView)
    }
}
