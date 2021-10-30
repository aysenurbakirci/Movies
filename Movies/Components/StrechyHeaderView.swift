//
//  StrechyHeaderView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 30.10.2021.
//

import Foundation
import UIKit

final class StrechyHeaderView: UIView {
    let imageView: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "defaultImage")
        return image
    }()
    
    private var imageHeight = NSLayoutConstraint()
    private var imageBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
    }
    
    func setViewConstraints() {
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        containerHeight = containerView.heightAnchor.constraint(equalTo: self.heightAnchor)
        containerHeight.isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageBottom.isActive = true
        imageHeight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageHeight.isActive = true
    }
    
    func apply(imagePath: String) {
        self.imageView.downloadImage(imageURL: imagePath, width: 500)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        containerHeight.constant = scrollView.contentInset.top
        
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        
        containerView.clipsToBounds = offsetY <= 0
        imageBottom.constant = offsetY >= 0 ? 0 : -(offsetY / 2)
        
        imageHeight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}
