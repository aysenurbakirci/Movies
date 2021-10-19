//
//  HorizontalScrollView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit

struct HorizontalListModel {
    var id: Int
    var imagePath: String
    var title: String
}


class HorizontalListScrollView : UIView {
    
    private var list: [HorizontalListModel] = []
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.contentSize = CGSize(width: stackView.frame.width, height: 120)
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(scrollView)
        scrollView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 20, left: 0, bottom: 20, right: 0))
        scrollView.anchorSize(size: scrollView.contentSize)
        
        scrollView.addSubview(stackView)
        stackView.fillSuperView()
        
        for i in 0..<20 {
            let view = ImageAndTitleCardView()
            view.tag = i
            view.apply(imageInfo: nil, title: "title")
            view.anchorSize(size: .init(width: scrollView.contentSize.height, height: scrollView.contentSize.height))
            view.backgroundColor = .gray
            view.layer.cornerRadius = 8
            
            stackView.addArrangedSubview(view)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(model: [HorizontalListModel]) {
        self.list = model
    }
    
}
