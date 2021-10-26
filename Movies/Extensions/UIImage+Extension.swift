//
//  UIImage+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import Kingfisher

extension UIImageView {
    
    func downloadImage(imageURL: String, width: Int?){
        let urlString = baseImageURL + "w\(width ?? 500)" + imageURL
        let url = URL(string: urlString)
        let activityIndicator = UIActivityIndicatorView()
        
        activityIndicator.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityIndicator.color = .red
        self.backgroundColor = .white
        self.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        self.kf.setImage(with: url, options: nil, progressBlock: nil) { result in
            activityIndicator.stopAnimating()
        }
    }
}
