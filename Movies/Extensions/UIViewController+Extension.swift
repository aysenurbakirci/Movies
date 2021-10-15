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

