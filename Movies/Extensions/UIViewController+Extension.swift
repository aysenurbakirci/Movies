//
//  UIViewController+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

import UIKit

protocol LoadingDisplayer {
    func showLoadingView()
    func hideLoadingView()
}

protocol EmptyViewDisplayer {
    func showEmptyView(_ message: String)
    func hideEmptyView()
}

extension LoadingDisplayer where Self: UIViewController {
    
    func showLoadingView() {
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
    
    func hideLoadingView() {
        self.view.viewWithTag(999)?.removeFromSuperview()
    }
}

extension EmptyViewDisplayer where Self: UIViewController {
    
    func showEmptyView(_ message: String) {
        
        let messageBackgroundView = UIView(frame: self.view.bounds)
        messageBackgroundView.layer.zPosition = .greatestFiniteMagnitude
        messageBackgroundView.tag = 998
        messageBackgroundView.backgroundColor = .white
        
        let messageLabel = UILabel(frame: self.view.bounds)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.sizeToFit()
        
        messageBackgroundView.addSubview(messageLabel)
        self.view.addSubview(messageBackgroundView)
        messageBackgroundView.fillSuperView()
        messageLabel.fillSuperView()
    }
    
    func hideEmptyView() {
        self.view.viewWithTag(998)?.removeFromSuperview()
    }
}

