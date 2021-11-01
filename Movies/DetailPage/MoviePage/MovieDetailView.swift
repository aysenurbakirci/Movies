//
//  MovieDetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 1.11.2021.
//

import Foundation
import UIKit

class MovieDetailView: UIView {
    
    lazy var header = StrechyHeader(frame: .init(x: 0,
                                                 y: 0,
                                                 width: UIScreen.main.bounds.size.width,
                                                 height: UIScreen.main.bounds.size.width * 0.4))
    
    lazy var tableView: UITableView = {
        var table = UITableView()
        table.tableHeaderView = header
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.fillSuperView()
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.reuseIdentifier)
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
