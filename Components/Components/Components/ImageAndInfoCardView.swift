//
//  ImageAndInfoCardView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import UIKit
import Extensions
import ImdbAPI

public final class ImageAndInfoCardView: UIView {
    
    private let titleAndSubtitle = TitleAndSubtitlesView()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var imageContainer: UIView = {
        var container = UIView()
        container.addSubview(image)
        return container
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .horizontal
        stack.addArrangedSubview(imageContainer)
        stack.addArrangedSubview(titleAndSubtitle)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(stack)
        image.fillSuperView()
        imageContainer.anchorSize(size: .init(width: 100, height: 100))
        stack.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func apply(imagePath: String, title: String, subtitle: String? = nil, secondSubtitle: String? = nil) {

        titleAndSubtitle.apply(title: title, subtitle: subtitle, secondSubtitle: secondSubtitle)
        self.image.downloadImage(imagePath: imagePath, width: 200)
    }
}
