//
//  MovieDetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import Foundation
import UIKit

class MovieDetailView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.fillSuperView()
        registerTableViewCells()
    }
    
    private func registerTableViewCells() {
        tableView.register(InformationCell.self, forCellReuseIdentifier: InformationCell.reuseIdentifier)
        tableView.register(PersonListCell.self, forCellReuseIdentifier: PersonListCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
