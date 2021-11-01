//
//  ImageAndTitleCardView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit
import Extensions
import MoviesAPI

public final class ImageAndTitleCardView: UIView {
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        
        var label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        image.fillSuperView()
        
        image.addSubview(title)
        title.anchor(top: nil, leading: image.leadingAnchor, bottom: image.bottomAnchor, trailing: image.trailingAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(imagePath: String?, title: String) {
        
        self.title.text = title
        
        guard let imagePath = imagePath else { return }
        self.image.downloadImage(imagePath: imagePath, width: 500)
    }
}
