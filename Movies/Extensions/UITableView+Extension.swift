//
//  UITableView+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 14.10.2021.
//

import UIKit

extension UIView {
    
    func loadingView(_ isLoading: Bool) {
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
        var blurView: UIVisualEffectView = UIVisualEffectView()
        
        blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        activityIndicator.center = blurView.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large
        activityIndicator.color = .white
        blurView.contentView.addSubview(activityIndicator)
        
        if isLoading {
            addSubview(blurView)
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            removeFromSuperview()
        }
    }

    func setEmptyMessage(_ message: String) {
        
        let emptyMessageView: UIView = UIView()
        emptyMessageView.translatesAutoresizingMaskIntoConstraints = false
        emptyMessageView.frame = UIWindow(frame: UIScreen.main.bounds).frame
        emptyMessageView.backgroundColor = .white
        
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()
        
        messageLabel.center = emptyMessageView.center

        emptyMessageView.addSubview(messageLabel)
        
        addSubview(emptyMessageView)
    }
}
