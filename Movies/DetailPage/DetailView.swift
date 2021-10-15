//
//  DetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

import UIKit

class DetailView: UIView {
    
    private let titleAndSubtitle = TitleAndSubtitlesView()
    
    private lazy var movieImage: UIImageView = {
        var imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.width)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(movieImage)
        backgroundColor = .white
        
        movieImage.anchorSize(size: .init(width: movieImage.frame.size.width, height: movieImage.frame.size.height))
        movieImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        addSubview(titleAndSubtitle)
        titleAndSubtitle.anchor(top: movieImage.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20.0, left: 20.0, bottom: 0.0, right: 20.0))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

