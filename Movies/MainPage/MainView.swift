//
//  MainView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import UIKit

class MovieView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(tableView)
        tableView.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
