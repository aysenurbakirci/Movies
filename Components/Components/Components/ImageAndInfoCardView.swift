//
//  ImageAndInfoCardView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import UIKit
import Extensions
import ImdbAPI

public struct ViewModelProperties {
    var imagePath: String
    var title: String
    var subTitle: String
    var secondSubtitle: String
    
    public init(imagePath: String, title: String, subTitle: String, secondSubtitle: String) {
        self.imagePath = imagePath
        self.title = title
        self.subTitle = subTitle
        self.secondSubtitle = secondSubtitle
    }
}

public final class ImageAndInfoCardView: UIView {
    
    private let titleAndSubtitle = TitleAndSubtitlesView()
    
    // MARK: - UI Components
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
    
    // MARK: - Init
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
    
    public func apply(with model: ViewModelProperties) {
        titleAndSubtitle.apply(title: model.title, subtitle: model.subTitle, secondSubtitle: model.secondSubtitle)
        self.image.downloadImage(imagePath: model.imagePath, width: 200)
    }
}
