//
//  DetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

import UIKit
import RxSwift
import Kingfisher

class DetailView: UIView {
    
    let clickLinkButton = PublishSubject<String>()
    private var link: String = ""
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        return scroll
    }()
    
    lazy var horizontalListView = HorizontalListCollectionView()
    
    private lazy var titleAndSubtitles = TitleAndSubtitlesView()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var overview: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var linkButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Go Trailer", for: .normal)
        button.tintColor = .red
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(image)
        stack.addArrangedSubview(titleAndSubtitles)
        stack.addArrangedSubview(overview)
        stack.addArrangedSubview(linkButton)
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
        
        self.image.downloadImage(imageURL: detailModel.imagePath ?? "", width: 500)
        self.titleAndSubtitles.apply(title: detailModel.title, subtitle: detailModel.subtitle, secondSubtitle: nil)
        self.overview.text = detailModel.overview
        if let link = detailModel.link {
            self.link = link
            linkButton.isHidden = false
        } else {
            linkButton.isHidden = true
        }
    }
    
    @objc private func buttonClick() {
        clickLinkButton.onNext(link)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
