//
//  HorizontalListCollectionViewCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 19.10.2021.
//

import UIKit

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
    
    func cellConfig(imageInfo: ImageInfo, title: String) {
        let image = ImageInfo(urlString: "", width: 500)
        imageAndTitleView.apply(imageInfo: image, title: "title")
    }
}
