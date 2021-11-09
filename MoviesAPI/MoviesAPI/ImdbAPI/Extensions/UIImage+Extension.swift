//
//  UIImage+Extension.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import Kingfisher

public extension UIImageView {
    func downloadImage(imagePath: String, width: Int?) {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "image.tmdb.org"
        urlComponents.path = "/t/p/" + "w\(width ?? 500)" + imagePath
        let url = urlComponents.url
        let placeholder = UIImage(named: "defaultImage")
        self.kf.setImage(with: url, placeholder: placeholder)
    }
}
