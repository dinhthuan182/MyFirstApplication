//
//  ChatLogController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    var user: User? {
        didSet {
            navigationItem.title = user?.fullName
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userMessagesRef = Ref().databaseSpecificUserMessages(uid: currentUid)
        userMessagesRef.observe(.childAdded, with: { (snapshot) in
            let messageUid = snapshot.key
            
            let messagesRef = Ref().databaseSpecificChat(uid: messageUid)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let messageDict = snapshot.value as? [String: AnyObject] else {
                    return
                }
                
                let message = Message()
                message.setValuesForKeys(messageDict)
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    let cellId = "cellId"
    let containerView = UIView()
    let messageTextField = UITextField()
    let sendButton = UIButton(type: .system)
    let separatorLineView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        self.setupInputComponents()
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.content
        
        setupCell(cell: cell, message: message)
        
        cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: message.content!).width + 27
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(urlString: profileImageUrl)
        }
        
        if message.fromUid == Auth.auth().currentUser?.uid {
            //message background is blue color
            cell.bubbleView.backgroundColor = ChatMessageCell.messageBlueColor
            cell.textView.textColor = .white
            
            cell.profileImageView.isHidden = true
            cell.bubbleViewLeftAuchor?.isActive = false
            cell.bubbleViewRightAuchor?.isActive = true
        } else {
            //mesage background id gray color
            cell.bubbleView.backgroundColor = UIColor.customRGB(240, 240, 240, 1)
            cell.textView.textColor = .black
            cell.profileImageView.isHidden = false
            cell.bubbleViewLeftAuchor?.isActive = true
            cell.bubbleViewRightAuchor?.isActive = false
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].content {
            height = estimateFrameForText(text: text).height + 15
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
    }
}
