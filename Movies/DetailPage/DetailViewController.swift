//
//  DetailViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit
import RxSwift

class DetailViewController: UIViewController, LoadingDisplayer {
    
    private lazy var detailView: DetailView = {
        var view = DetailView()
        return view
    }()
    
    var detailViewModel: DetailViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
        detailViewModel
            .data
            .subscribe(onNext: { [weak self] data in
                guard let data = data, let self = self else { return }
                self.detailView.apply(detailModel: data)
                self.detailView.horizontalListView.dataArrayRelay.accept(data.castArray)
            })
            .disposed(by: disposeBag)
        
        detailViewModel
            .isLoading
            .subscribe(onNext: { [weak self] isLoading in
                if isLoading {
                    self?.showLoadingView()
                } else {
                    self?.hideLoadingView()
                }
            })
            .disposed(by: disposeBag)
        
        detailView.horizontalListView
            .selectedItemId
            .skip(1)
            .subscribe(onNext: { [weak self] id in
                guard let self = self else { return }
                self.navigationController?.pushViewController(self.detailViewModel.openNewDetailPage(id: id), animated: true)
            })
            .disposed(by: disposeBag)
        
        detailViewModel.loadData.onNext(())
    }
}

