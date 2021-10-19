//
//  DetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

import UIKit
import Kingfisher

class DetailView: UIView {
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private lazy var horizontalListView = HorizontalListCollectionView()
    
    private lazy var titleAndSubtitles = TitleAndSubtitlesView()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var overview: UILabel = {
        var label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        var button = UIButton(type: .system)
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.backgroundColor = .white
        button.setImage(UIImage(named: "play.svg"), for: .normal)
        button.tintColor = .black
        button.addShadow(cornerRadius: 20)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(titleAndSubtitles)
        stack.addArrangedSubview(overview)
        stack.addArrangedSubview(horizontalListView)
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        detailViewConfig()
    }
    
    private func detailViewConfig() {
        self.addSubview(scrollView)

        scrollView.fillSuperView()
        scrollView.addSubview(stack)
        stack.fillSuperView()
        stack.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func apply(detailModel: DetailModel) {
        
        self.image.downloadImage(imageURL: detailModel.image?.urlString ?? "", width: detailModel.image?.width)
        self.titleAndSubtitles.apply(title: detailModel.title, subtitle: detailModel.subtitle, secondSubtitle: nil)
        self.overview.text = detailModel.overview
        
        if let buttonImage = detailModel.buttonImageName {
            self.linkButton.setImage(UIImage(named: buttonImage), for: .normal)
        } else {
            self.linkButton.isHidden = true
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
