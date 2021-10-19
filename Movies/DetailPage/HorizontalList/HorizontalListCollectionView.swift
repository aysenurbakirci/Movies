//
//  HorizontalListCollectionView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 19.10.2021.
//

import UIKit

final class HorizontalListCollectionView: UIView {
    
    static let cellWidthRatio: CGFloat = 0.37
    static let cellHeightRatio: CGFloat = 1

    static let cellWidth = UIScreen.main.bounds.size.width * cellWidthRatio
    static let cellHeight = cellWidth * cellHeightRatio
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: HorizontalListCollectionView.cellWidth,
                                 height: HorizontalListCollectionView.cellHeight)
        layout.minimumInteritemSpacing = 12.0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15.0, bottom: 0, right: 15.0)
        layout.scrollDirection = .horizontal
        layout.invalidateLayout()
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(HorizontalListCollectionViewCell.self,
                                forCellWithReuseIdentifier: HorizontalListCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(collectionView)
        collectionView.fillSuperView()
        collectionView.heightAnchor.constraint(equalToConstant: HorizontalListCollectionView.cellHeight).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HorizontalListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalListCollectionViewCell.reuseIdentifier, for: indexPath) as? HorizontalListCollectionViewCell else {
            fatalError("can not deque cell with identifier")
        }

        return cell
    }
}

extension HorizontalListCollectionView: UICollectionViewDelegate {
    
}
