//
//  MainTableViewCellViewModel.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 13.10.2021.
//

import Foundation

protocol MainTableViewCellProtocol {
    var image: ImageInfo? { get }
    var title: TextConfiguration { get }
    var subtitle: TextConfiguration? { get }
    var secondSubtitle: TextConfiguration? { get }
}
