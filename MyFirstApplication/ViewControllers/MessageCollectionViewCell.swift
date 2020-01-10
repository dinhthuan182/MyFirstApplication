//
//  MessageCollectionViewCell.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

class MessageCollectionViewCell: UICollectionViewCell {
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 34
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    let contentStackView = UIStackView()
    let senderLabel = UILabel()
    let messageLabel = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .cyan
        self.setupImageView()
        self.setupContentView()
    }
}

extension MessageCollectionViewCell {
    
    private func setupImageView() {
        self.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "mark-zuckerberg")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.frame.size = CGSize(width: 68, height: 68)
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
    }
    
    private func setupContentView() {
    }
}
