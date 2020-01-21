//
//  MessageCollectionViewCell.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {
    
    var pan: UIPanGestureRecognizer!
    
    let rightSwipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let leftSwipeView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 35
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let containerView = UIView()
    let senderLabel: UILabel = {
        let label = UILabel()
        label.text = "Mark Zuckerberg"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "15:00 PM"
        label.textColor = UIColor.customRGB(51, 51, 70, 0.8)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()

    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Hello, I am CEO of Facebook. Nice to meet you."
        label.textColor = UIColor.customRGB(51, 51, 70, 0.8)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let hasReadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var message: Message? {
        didSet {
            self.setupNameAndAvatar()
            self.messageLabel.text = message?.content
            if let seconds = message?.timestamp?.doubleValue {
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "hh:mm a"
                self.timeLabel.text = dateFormatter.string(from: timestampDate as Date)
            }
        }
    }
    
    private func setupNameAndAvatar() {
        
        if let uid = message?.chatPartnerId() {
            Ref().databaseSpecificUser(uid: uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                
                    self.profileImageView.loadImageUsingCacheWithUrlString(urlString: dictionary[PROFILE_IMAGE_URL] as! String)
                    self.hasReadImageView.loadImageUsingCacheWithUrlString(urlString: dictionary[PROFILE_IMAGE_URL] as! String)
                    self.senderLabel.text = dictionary[FULLNAME] as? String
                    
                }
            }, withCancel: nil)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .cyan
        self.setupImageView()
        self.setupContainerView()
        self.setupSwipeView()
    }
}

//set up UI for cell
extension MessageCollectionViewCell {
    //auto layout for avatar of sender
    private func setupImageView() {
        self.addSubview(profileImageView)
        profileImageView.image = UIImage(named: "mark-zuckerberg")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        addConstraint(NSLayoutConstraint(item: profileImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    //auto layout for text area
    private func setupContainerView() {
        self.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            containerView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 70)
        ])
        addConstraint(NSLayoutConstraint(item: containerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        //auto layout for name of sender
        containerView.addSubview(senderLabel)
        senderLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            senderLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            senderLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            senderLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 7.0 / 9.0)
        ])
        
        containerView.addSubview(timeLabel)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            timeLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 2.0 / 9.0)
        ])
        
        //auto layout for message content
        containerView.addSubview(messageLabel)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: senderLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            messageLabel.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 8.0 / 9.0)
        ])
        
        //auto layout for image check status of message
        containerView.addSubview(hasReadImageView)
        hasReadImageView.image = UIImage(named: "mark-zuckerberg")
        hasReadImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hasReadImageView.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5),
            hasReadImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            hasReadImageView.widthAnchor.constraint(equalToConstant: 16),
            hasReadImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
    }
    
    func setupSwipeView()  {
        self.insertSubview(rightSwipeView, belowSubview: self.contentView)
        self.insertSubview(leftSwipeView, belowSubview: self.contentView)
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        
    }
    
    override func layoutSubviews() {
        let p: CGPoint = pan.translation(in: self)
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        self.contentView.frame = CGRect(x: p.x,y: 0, width: width, height: height);
        self.leftSwipeView.frame = CGRect(x: p.x - leftSwipeView.frame.size.width - 10, y: 0, width: width, height: height)
        self.rightSwipeView.frame = CGRect(x: p.x + width, y: 0, width: width, height: height)
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {

        } else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }
}
