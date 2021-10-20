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
                let controller = self.detailViewModel.openNewDetailPage(id: id)
                self.navigationController?.pushViewController(controller, animated: true)
            })
            .disposed(by: disposeBag)
        
        detailView
            .clickLinkButton
            .subscribe(onNext: { [weak self] link in
                self?.detailViewModel.openLink(linkKey: link)
            })
            .disposed(by: disposeBag)
        
        detailViewModel.loadData.onNext(())
    }
}

