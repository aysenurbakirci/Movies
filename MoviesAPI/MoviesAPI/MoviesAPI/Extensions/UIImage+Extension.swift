//
//  UIImage+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import Kingfisher

public extension UIImageView {
    func downloadImage(imagePath: String, width: Int?){
        let urlString = "https://image.tmdb.org/t/p/" + "w\(width ?? 500)" + imagePath
        let url = URL(string: urlString)
        self.kf.setImage(with: url, placeholder: UIImage(named: "defaultImage"), options: nil, progressBlock: nil)
    }
}
