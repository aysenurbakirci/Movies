//
//  DetailView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 1.11.2021.
//

import Foundation
import UIKit

class DetailView: UIView {
    
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
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

