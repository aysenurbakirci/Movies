//
//  ImageAndTitleCardView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit

class ImageAndTitleCardView: UIView {
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage.jpg")
        imageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView.layer.cornerRadius = 6
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var title: UITextView = {
        
        var textView = UITextView()
        textView.textAlignment = .center
        textView.text = "Title"
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = UIColor.black
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        return textView
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(image)
        image.fillSuperView()
        
        image.addSubview(title)
        title.anchor(top: nil, leading: image.leadingAnchor, bottom: image.bottomAnchor, trailing: image.trailingAnchor)
        title.anchorSize(size: .init(width: frame.width, height: title.contentSize.height))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(imageInfo: ImageInfo?, title: String) {
        
        self.title.text = title

        if let imageInfo = imageInfo {
            self.image.downloadImage(imageURL: imageInfo.urlString, width: imageInfo.width)
        }
        
    }
}
