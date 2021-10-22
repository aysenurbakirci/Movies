//
//  Loading.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 21.10.2021.
//

import Foundation
import RxSwift
import RxCocoa

typealias ActivityHandler = ViewModel & RemoteLoading
typealias ActivityDisplayer = View & ErrorDisplayer & LoadingDisplay


protocol ViewModel {}

protocol View: AnyObject {
    associatedtype VM: ViewModel
    var viewModel: VM { get }
    var bag: DisposeBag { get }
}

protocol RemoteLoading {
    var isLoading: BehaviorRelay<Bool> { get }
    var onError: BehaviorRelay<Error> { get  }
}

protocol LoadingDisplay {
    var isLoadingData: Binder<(Bool)> { get }
}

protocol ErrorDisplayer {
    var errorObject: Binder<Error?> { get }
}

extension LoadingDisplay where Self: UIViewController {
    var isLoadingData: Binder<(Bool)> {
        return Binder(self) { _, loadingData in
            loadingData ? GiFHUD.showWithOverlay() : GiFHUD.dismiss()
        }
    }
}

extension ErrorDisplayer where Self: UIViewController {
    var errorObject: Binder<Error> {
        return Binder(self) { _, error in
            print("ERROR")
        }
    }
}

extension View where Self: ErrorDisplayer, Self.VM: RemoteLoading {
    func binderrorHandling() {
        viewModel.onError
            .asObservable()
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] err in
                self?.errorObject.on(.next(err))
            })
            .disposed(by: bag)
    }
    
}

extension View where Self: LoadingDisplay, Self.VM: RemoteLoading {
    func bindLoading() {
        viewModel.isLoading
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: isLoadingData)
            .disposed(by: bag)
    }
}
