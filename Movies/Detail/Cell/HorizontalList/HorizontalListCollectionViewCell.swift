//
//  HorizontalListCollectionViewCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 19.10.2021.
//

import UIKit
import Components

class HorizontalListCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier: String = "horizontalListCollectionViewCellId"
    
    private lazy var imageAndTitleView = ImageAndTitleCardView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageAndTitleView)
        imageAndTitleView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellConfig(imagePath: String, title: String) {
        imageAndTitleView.apply(imagePath: imagePath, title: title)
    }
}
