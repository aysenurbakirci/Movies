//
//  ViewDisplayer.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 21.10.2021.
//

import Foundation
import RxSwift
import RxCocoa
import Extensions

public typealias ActivityHandler = ViewModel & RemoteLoading
public typealias ActivityDisplayer = View & ErrorDisplayer & LoadingDisplayer & EmptyDisplayer

public protocol ViewModel {}

public protocol View: AnyObject {
    associatedtype VM: ViewModel
    var viewModel: VM { get }
    var bag: DisposeBag { get }
}

public protocol RemoteLoading {
    var isLoading: BehaviorRelay<Bool> { get }
    var isEmptyData: BehaviorRelay<Bool> { get }
    var onError: BehaviorRelay<Error?> { get }
}

public protocol LoadingDisplayer {
    var isLoadingData: Binder<Bool> { get }
}

public protocol ErrorDisplayer {
    var errorObject: Binder<Error?> { get }
}

public protocol EmptyDisplayer {
    var isEmptyData: Binder<Bool> { get }
}

public extension LoadingDisplayer where Self: UIViewController {
    var isLoadingData: Binder<Bool> {
        return Binder(self) { [weak self] _, loadingData in
            guard let self = self else { return }
            loadingData ? self.showLoadingView() : self.hideLoadingView()
        }
    }
    
    private func showLoadingView() {
        let activityIndicatorView = UIView(frame: self.view.bounds)
        activityIndicatorView.layer.zPosition = .greatestFiniteMagnitude
        activityIndicatorView.tag = 999
        activityIndicatorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicatorView.addSubview(activityIndicator)
        self.view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperView()
        activityIndicator.fillSuperView()
    }
    
    private func hideLoadingView() {
        self.view.viewWithTag(999)?.removeFromSuperview()
    }
}

public extension EmptyDisplayer where Self: UIViewController {
    var isEmptyData: Binder<Bool> {
        return Binder(self) { [weak self] _, isEmpty in
            guard let self = self else { return }
            isEmpty ? self.showEmptyView() : self.hideEmptyView()
        }
    }
    
    private func showEmptyView() {
        let messageBackgroundView = UIView(frame: self.view.bounds)
        messageBackgroundView.layer.zPosition = .greatestFiniteMagnitude
        messageBackgroundView.tag = 998
        messageBackgroundView.backgroundColor = .white
        
        let messageLabel = UILabel(frame: self.view.bounds)
        messageLabel.text = "We couldn't find what you were looking for..."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        messageBackgroundView.addSubview(messageLabel)
        self.view.addSubview(messageBackgroundView)
        messageBackgroundView.fillSuperView()
        messageLabel.fillSuperView()
    }
    
    private func hideEmptyView() {
        self.view.viewWithTag(998)?.removeFromSuperview()
    }
}

public extension ErrorDisplayer where Self: UIViewController {
    var errorObject: Binder<Error?> {
        return Binder(self) { [weak self] _, error in
            self?.makeErrorAlert(error?.localizedDescription ?? "invalid error.")
        }
    }
    
    func makeErrorAlert(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Ok", style: .cancel) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}

public extension View where Self: ErrorDisplayer, Self.VM: RemoteLoading {
    func bindErrorHandling() {
        viewModel.onError
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] err in
                self?.errorObject.on(.next(err))
            })
            .disposed(by: bag)
    }
}

public extension View where Self: LoadingDisplayer, Self.VM: RemoteLoading {
    func bindLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .bind(to: isLoadingData)
            .disposed(by: bag)
    }
}

public extension View where Self: EmptyDisplayer, Self.VM: RemoteLoading {
    func bindEmptyView() {
        viewModel
            .isEmptyData
            .observe(on: MainScheduler.instance)
            .bind(to: isEmptyData)
            .disposed(by: bag)
    }
}
