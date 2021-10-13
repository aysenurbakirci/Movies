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
    
    func cellConfig(withViewModel viewModel: MainTableViewCellProtocol) {
        
        cellView.apply(stackAxis: .horizontal, imageInfo: viewModel.image, title: viewModel.title, subtitle: viewModel.subtitle, secondSubtitle: viewModel.secondSubtitle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
