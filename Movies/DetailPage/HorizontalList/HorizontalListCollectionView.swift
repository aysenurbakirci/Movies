//
//  HorizontalListCollectionView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 19.10.2021.
//

import UIKit
import RxSwift
import RxCocoa

final class HorizontalListCollectionView: UIView {
    
    let dataArrayRelay = BehaviorRelay<[HorizontalListModel]>(value: [])
    let selectedItemId = BehaviorRelay<Int>(value: 0)
    let disposeBag = DisposeBag()
    
    static let cellWidthRatio: CGFloat = 0.37
    static let cellHeightRatio: CGFloat = 1.4

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
    
    lazy var collectionView: UICollectionView = {
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
        
        dataArrayRelay
            .subscribe(onNext: { [weak self] data in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HorizontalListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArrayRelay.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let model = dataArrayRelay.value[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HorizontalListCollectionViewCell.reuseIdentifier, for: indexPath) as? HorizontalListCollectionViewCell else {
            fatalError("can not deque cell with identifier")
        }
        cell.cellConfig(imageInfo: ImageInfo(urlString: model.imagePath, width: 500), title: model.title)
        return cell
    }
}

extension HorizontalListCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArrayRelay.value[indexPath.row]
        selectedItemId.accept(model.id)
    }
}
