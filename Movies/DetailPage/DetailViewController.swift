//
//  DetailViewController.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 17.10.2021.
//

import UIKit

class DetailViewController: UIViewController {
    
    let detailView = DetailView()
    var detailViewModel: DetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = detailView
    }
}
