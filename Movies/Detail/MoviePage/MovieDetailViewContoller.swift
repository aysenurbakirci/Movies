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
    
    private lazy var detailView: MovieDetailView = {
        var view = MovieDetailView()
        view.tableView.delegate = self
        view.tableView.dataSource = self
        return view
    }()
    
    var viewModel: MovieDetailViewModel!
    private let disposeBag = DisposeBag()
    
    private var loadData = PublishSubject<Void>()
    private var openPersonDetailPage = PublishSubject<Int>()
    private var openMovieTrailer = PublishSubject<String>()
    private var data = BehaviorRelay<[MovieViewSections]>(value: [])
    
    init(movieId: Int) {
        self.viewModel = MovieDetailViewModel(input: MovieDetailViewModelInput(movieId: movieId,
                                                                               detailService: DetailApi(),
                                                                               loadDataTrigger: loadData.asDriver(onErrorDriveWith: .never()),
                                                                               openPersonTrigger: openPersonDetailPage.asDriver(onErrorDriveWith:  .never()),
                                                                               openLinkTrigger: openMovieTrailer.asDriver(onErrorDriveWith:  .never())))
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view = detailView
        clearNavigationBarConfig()
        
        let output = viewModel.transform()
        
        output
            .data
            .do(onNext: { [weak self] movie in
                self?.data.accept(movie)
            })
            .drive(onNext: { [weak self] _ in
                self?.detailView.tableView.reloadData()
            })
            .disposed(by: disposeBag)
        
        output
            .isLoading
            .drive(onNext: { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    self.showLoadingView()
                } else {
                    self.hideLoadingView()
                }
            })
            .disposed(by: disposeBag)
        
        output
            .openMovieDetailController
            .drive(onNext: { [weak self] controller in
                self?.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        loadData.onNext(())
        
    }
    
    private func clearNavigationBarConfig() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.value.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = data.value[indexPath.section]
        
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
                    self.openMovieTrailer.onNext(key)
                })
                .disposed(by: cell.disposeBag)
            
            detailView.header.apply(imagePath: movieDetail.backdropPath ?? "")
            
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
                    self.openPersonDetailPage.onNext(id)
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
