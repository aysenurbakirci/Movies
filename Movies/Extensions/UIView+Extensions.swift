//
//  UIView+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import UIKit

extension UIView {
    
    func fillSuperView() {
        translatesAutoresizingMaskIntoConstraints = false
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSizetoSize(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorCenterX(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func anchorCenterY(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func anchorSize(size: CGSize) {
        translatesAutoresizingMaskIntoConstraints = false
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
    }
}

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
