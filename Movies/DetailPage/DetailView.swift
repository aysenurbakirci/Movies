//
//  DetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 15.10.2021.
//

import UIKit
import Kingfisher

class DetailView: UIView {
    
    let dummyText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vestibulum sed arcu non odio euismod lacinia at quis. Purus gravida quis blandit turpis. Sed libero enim sed faucibus turpis in. Nisi quis eleifend quam adipiscing vitae proin. Senectus et netus et malesuada fames. Sit amet porttitor eget dolor morbi non arcu. Sem fringilla ut morbi tincidunt augue interdum. Phasellus faucibus scelerisque eleifend donec pretium vulputate sapien nec. Eu non diam phasellus vestibulum lorem sed risus ultricies. Sagittis eu volutpat odio facilisis mauris sit amet massa vitae. Sit amet purus gravida quis. Elementum tempus egestas sed sed risus pretium quam. Commodo elit at imperdiet dui accumsan sit amet nulla. Blandit cursus risus at ultrices mi tempus imperdiet nulla. Justo laoreet sit amet cursus sit amet."
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .white
        return scroll
    }()
    
    private lazy var horizontalScrollView = HorizontalScrollView()
    
    private lazy var titleAndSubtitles = TitleAndSubtitlesView()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "defaultImage.jpg")
        imageView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var overview: UITextView = {
        var textView = UITextView()
        textView.textAlignment = .left
        textView.text = dummyText
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = .gray
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        return textView
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        detailViewConfig()
    }
    
    private func detailViewConfig() {
        self.addSubview(scrollView)

        scrollView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        
        scrollView.addSubview(image)
        image.anchorSize(size: .init(width: image.frame.size.width, height: image.frame.size.height))
        image.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor)
        
        scrollView.addSubview(titleAndSubtitles)
        titleAndSubtitles.anchor(top: image.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor)
        titleAndSubtitles.anchorSize(size: .init(width: titleAndSubtitles.frame.width, height: 80))
        
        scrollView.addSubview(overview)
        overview.anchor(top: titleAndSubtitles.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor)
        overview.anchorSize(size: .init(width: overview.frame.width, height: overview.contentSize.height + 80))
        
        scrollView.addSubview(horizontalScrollView)
        horizontalScrollView.anchor(top: overview.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor)
        
        image.addSubview(linkButton)
        linkButton.anchor(top: image.topAnchor, leading: nil, bottom: nil, trailing: image.trailingAnchor, padding: .init(top: 10, left: 0, bottom: 0, right: 10))
        linkButton.anchorSize(size: linkButton.frame.size)
    }
    
    func apply(detailModel: DetailModel) {
        
        self.image.downloadImage(imageURL: detailModel.image?.urlString ?? "", width: detailModel.image?.width)
        self.titleAndSubtitles.apply(title: detailModel.title, subtitle: detailModel.subtitle, secondSubtitle: nil)
        self.overview.text = detailModel.overview
        self.horizontalScrollView.apply(model: detailModel.castArray ?? [])
        
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
