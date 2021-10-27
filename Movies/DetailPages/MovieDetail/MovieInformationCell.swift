//
//  MovieInformationCell.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 25.10.2021.
//

import UIKit
import RxSwift
import Kingfisher

class MovieInformationCell: UITableViewCell {
    
    static let reuseIdentifier = "movieInformationCellId"
    private lazy var titleAndSubtitles = TitleAndSubtitlesView()
    let disposeBag = DisposeBag()
    
    private let imageHeightRatio: CGFloat = 0.6
    private let imageWidth = UIScreen.main.bounds.size.width
    private lazy var imageHeight = imageWidth * imageHeightRatio
    
    let imageIsLoad = PublishSubject<Void>()
    
    private lazy var image: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
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
        stack.addArrangedSubview(image)
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
//        image.anchorSize(size: .init(width: imageWidth, height: imageHeight))
        stack.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func apply(detailModel: MovieDetail) {
        guard let imagePath = detailModel.backdropPath else { return }
        let urlString = baseImageURL + "w\(500)" + imagePath
        let url = URL(string: urlString)
        self.image.kf.setImage(with: url, options: nil, progressBlock: nil) { [weak self] _ in
            self?.imageIsLoad.on(.next(()))
        }
        self.titleAndSubtitles.apply(title: detailModel.title, subtitle: String(detailModel.voteAverage), secondSubtitle: nil)
        self.overview.text = detailModel.overview
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

