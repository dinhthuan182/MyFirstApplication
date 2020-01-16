//
//  ChatMessageCell.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/15/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    static let messageBlueColor = UIColor.customRGB(0, 137, 249, 1)
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = messageBlueColor
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
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAuchor: NSLayoutConstraint?
    var bubbleViewLeftAuchor: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(bubbleView)
        self.addSubview(textView)
        self.addSubview(profileImageView)
        
        bubbleView.addSubview(messageImageView)
        NSLayoutConstraint.activate([
            messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor),
            messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor),
            messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor)
        ])
        
        bubbleViewRightAuchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAuchor = bubbleView.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8)
        
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleViewLeftAuchor?.isActive = false
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.topAnchor),
            bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor),
            bubbleViewRightAuchor!,
            bubbleWidthAnchor!
        ])
        
        NSLayoutConstraint.activate([
        textView.topAnchor.constraint(equalTo: self.topAnchor),
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8),
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor),
        textView.heightAnchor.constraint(equalTo: self.heightAnchor)])
        
        NSLayoutConstraint.activate([
            profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            profileImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 31),
            profileImageView.heightAnchor.constraint(equalToConstant: 31)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
