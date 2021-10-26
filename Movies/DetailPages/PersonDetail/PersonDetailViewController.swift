//
//  PersonDetailViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit
import RxSwift

class PersonDetailViewController: UIViewController, LoadingDisplay {

    private lazy var detailView: PersonDetailView = {
        var view = PersonDetailView()
        return view
    }()
    
    var viewModel: PersonDetailViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        
        viewModel
            .data
            .subscribe(onNext: { [weak self] data in
                guard let data = data, let self = self else { return }
                self.detailView.apply(detailModel: data)
                let listModel = ListModel(personMovies: data.movieCredits).castArray
                self.detailView.horizontalListView.dataArrayRelay.accept(listModel)
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
        
        detailView.horizontalListView
            .selectedItemId
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                let controller = self.viewModel.openNewDetailPage(id: id)
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.getDetails()
    }
}

