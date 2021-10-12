//
//  ImageAndInfoCardView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import UIKit

struct ImageInfo {
    let urlString: String
    let width: Int
}

class ImageAndInfoCardView: UIView {
    
    private let titleAndSubtitle = TitleAndSubtitlesView()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "unnamed.png")
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var stack = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        backgroundColor = .white

        stack.addArrangedSubview(image)
        image.anchorSize(size: .init(width: image.frame.size.width, height: image.frame.size.height))
        stack.addArrangedSubview(titleAndSubtitle)
        stack.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 10.0, left: 10.0, bottom: 10.0, right: 0.0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(stackAxis: NSLayoutConstraint.Axis, imageInfo: ImageInfo?, title: TextConfiguration, subtitle: TextConfiguration? = nil, secondSubtitle: TextConfiguration? = nil) {
        
        stack.axis = stackAxis

        titleAndSubtitle.apply(title: title, subtitle: subtitle, secondSubtitle: secondSubtitle)
        
        if let imageInfo = imageInfo {
            self.image.downloadImage(imageURL: imageInfo.urlString, width: imageInfo.width)
        } else {
            self.image.image = UIImage(named: "emptyImage")
        }
    }
}
