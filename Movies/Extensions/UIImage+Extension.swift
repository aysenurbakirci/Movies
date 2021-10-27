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
        self.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"), options: nil, progressBlock: nil)
    }
}
