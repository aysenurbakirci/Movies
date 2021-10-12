//
//  TitleAndSubtitlesView.swift
//  Movies
//
//  Created by Ayşenur Bakırcı on 12.10.2021.
//

import Foundation
import UIKit

struct TextConfiguration {
    let title: String
    let titleFont: UIFont?
    let titleColor: UIColor?
}

class TitleAndSubtitlesView: UIView {
    
    private lazy var title: UITextView = {
        
        var textView = UITextView()
        textView.textAlignment = .left
        textView.text = "Movie Title"
        textView.font = UIFont.boldSystemFont(ofSize: 18)
        textView.textColor = UIColor.black
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        return textView
        
    }()
    
    private lazy var subtitleOne: UITextView = {
        
        var textView = UITextView()
        textView.textAlignment = .left
        textView.text = "0.0"
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = UIColor.gray
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        return textView
        
    }()
    
    private lazy var subtitleTwo: UITextView = {
        
        var textView = UITextView()
        textView.textAlignment = .left
        textView.text = "0.0"
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.textColor = UIColor.gray
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        return textView
        
    }()
    
    private lazy var verticalStack: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
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
    
    func apply(title: TextConfiguration, subtitle: TextConfiguration? = nil, secondSubtitle: TextConfiguration? = nil) {
        
        self.title.text = title.title
        
        if let titleFont = title.titleFont {
            self.title.font = titleFont
        }
        
        if let titleColor = title.titleColor {
            self.title.textColor = titleColor
        }
        
        guard let subtitle = subtitle else {
            subtitleOne.isHidden = true
            return
        }
        
        subtitleOne.text = subtitle.title

        if let subtitleFont = subtitle.titleFont {
            subtitleOne.font = subtitleFont
        }
        
        if let subtitleColor = subtitle.titleColor {
            subtitleOne.textColor = subtitleColor
        }
        
        guard let secondSubtitle = secondSubtitle else {
            subtitleTwo.isHidden = true
            return
        }
        
        subtitleTwo.text = secondSubtitle.title

        if let subtitleFont = secondSubtitle.titleFont {
            subtitleTwo.font = subtitleFont
        }
        
        if let subtitleColor = secondSubtitle.titleColor {
            subtitleTwo.textColor = subtitleColor
        }
    }
}
