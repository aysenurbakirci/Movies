//
//  PersonListCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import UIKit
import RxSwift

class ListCell: UITableViewCell {
    
    //MARK: - Properties
    static let reuseIdentifier = "personListCellId"
    lazy var horizontalListView = HorizontalListCollectionView()
    let disposeBag = DisposeBag()
    
    //MARK: - Initalization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(horizontalListView)
        horizontalListView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
