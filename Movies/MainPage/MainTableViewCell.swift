//
//  MainTableViewCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "mainTableViewCellID"
    
    private let cellView = ImageAndInfoCardView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(cellView)
        cellView.fillSuperView()
        
    }
    
    func cellConfiguration() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
