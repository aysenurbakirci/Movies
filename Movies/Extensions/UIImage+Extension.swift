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
        let activityInd = UIActivityIndicatorView()
        
        activityInd.center = CGPoint(x: self.frame.size.width  / 2, y: self.frame.size.height / 2)
        activityInd.color = .white
        self.backgroundColor = .lightGray
        self.addSubview(activityInd)
        activityInd.startAnimating()
        self.kf.setImage(with: url, options: nil, progressBlock: nil) { result in
        activityInd.stopAnimating()
            
        }
    }
}
