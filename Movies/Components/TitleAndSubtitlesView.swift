//
//  TitleAndSubtitlesView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import UIKit

class TitleAndSubtitlesView: UIView {
    
    private lazy var title: UILabel = {
        
        var label = UILabel()
        label.textAlignment = .left
        label.text = "Movie Title"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        return label
        
    }()
    
    private lazy var subtitleOne: UILabel = {
        
        var label = UILabel()
        label.textAlignment = .left
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
        
    }()
    
    private lazy var subtitleTwo: UILabel = {
        
        var label = UILabel()
        label.textAlignment = .left
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.gray
        label.numberOfLines = 0
        return label
        
    }()
    
    private lazy var verticalStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(verticalStack)
        verticalStack.addArrangedSubview(title)
        verticalStack.addArrangedSubview(subtitleOne)
        verticalStack.addArrangedSubview(subtitleTwo)
        verticalStack.fillSuperView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func apply(title: String, subtitle: String? = nil, secondSubtitle: String? = nil) {
        
        self.title.text = title
        
        if let subtitle = subtitle {
            subtitleOne.text = subtitle
            subtitleOne.isHidden = false
        } else {
            subtitleOne.isHidden = true
        }
        
        
        if let secondSubtitle = secondSubtitle {
            subtitleTwo.text = secondSubtitle
            subtitleOne.isHidden = false
        } else {
            subtitleTwo.isHidden = true
        }
        
    }
}
