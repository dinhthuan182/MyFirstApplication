//
//  ChatMessageCell.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/15/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.customRGB(0, 137, 249, 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Example message"
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bubbleView)
        self.addSubview(textView)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor)
        ])
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        NSLayoutConstraint.activate([
        textView.topAnchor.constraint(equalTo: self.topAnchor),
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor),
        textView.heightAnchor.constraint(equalTo: self.heightAnchor)])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
