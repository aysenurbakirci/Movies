//
//  MovieInformationCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import UIKit
import RxSwift
import Kingfisher
import MoviesAPI
import Components

class InformationCell: UITableViewCell {
    
    static let reuseIdentifier = "movieInformationCellId"
    private lazy var titleAndSubtitles = TitleAndSubtitlesView()
    let disposeBag = DisposeBag()

    private lazy var overview: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    private(set) lazy var linkButton: UIButton = {
        var button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitle("Go Trailer", for: .normal)
        button.tintColor = .red
        return button
    }()
    
    private lazy var stack: UIStackView = {
        var stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.addArrangedSubview(titleAndSubtitles)
        stack.addArrangedSubview(overview)
        stack.addArrangedSubview(linkButton)
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        detailViewConfig()
    }
    
    private func detailViewConfig() {
        contentView.addSubview(stack)
        stack.fillSuperView()
        stack.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func apply(movieDetail: MovieDetail) {
        self.titleAndSubtitles.apply(title: movieDetail.title, subtitle: String(movieDetail.voteAverage), secondSubtitle: nil)
        self.overview.text = movieDetail.overview
        self.linkButton.isHidden = false
    }
    
    func apply(personDetail: PersonDetail) {
        self.titleAndSubtitles.apply(title: personDetail.name, subtitle: nil, secondSubtitle: nil)
        self.overview.text = personDetail.biography
        self.linkButton.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

