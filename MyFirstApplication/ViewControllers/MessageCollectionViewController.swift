//
//  MessageViewController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    private let cellId = "cellId"
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        collectionView.register(MessageCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupNavigationItem()
       
    }
    
    func setupNavigationItem() {
        self.navigationItem.title = Auth.auth().currentUser?.email
        messages.removeAll()
        messagesDictionary.removeAll()
        self.collectionView.reloadData()
        
        observeUserMessage()
    }
    
    func observeUserMessage() {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let userRef = Ref().databaseSpecificUserMessages(uid: currentUid)
        userRef.observe(.childAdded, with: { (snapshot) in
            let chatPartnerUid = snapshot.key
            Ref().databaseSpecificUserMessages(uid: currentUid).child(chatPartnerUid).observe(.childAdded, with: { (snapshot) in
                let messageId = snapshot.key
                self.fetchMessageWithMessageUid(messageUid: messageId)
                
            }, withCancel: nil)
            self.attemptReloadOfCollection()
            
        }, withCancel: nil)
        
        userRef.observe(.childRemoved, with: { (snapshot) in
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            self.attemptReloadOfCollection()
        }, withCancel: nil)
    }
    
    func fetchMessageWithMessageUid(messageUid: String) {
        let messagesRef = Ref().databaseSpecificChat(uid: messageUid)
        messagesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let dict = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dict)
                
                if let chatPartnerUid = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerUid] = message
                    self.messages = Array(self.messagesDictionary.values)
                    self.messages.sort { (message1, message2) -> Bool in
                        return message1.timestamp!.intValue > message2.timestamp!.intValue
                    }
                }
                
                //reduce loaded data
                self.attemptReloadOfCollection()
            }
        }, withCancel: nil)
    }
    
    func attemptReloadOfCollection() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadCollection() {
        DispatchQueue.main.async {
            //reload data of message collection
            self.collectionView.reloadData()
        }
    }
    
    //MARK:- UICollectionViewController
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MessageCollectionViewCell
        cell.setupUI()
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }

    //MARK:- UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    func showChatLog(user: User) {
        let layout = UICollectionViewFlowLayout()
        let controller = ChatLogController(collectionViewLayout: layout)
        controller.user = user
        self.hidesBottomBarWhenPushed  = true
        navigationController?.pushViewController(controller, animated: true)
        self.hidesBottomBarWhenPushed = false

    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerUid = message.chatPartnerId() else {
            return
        }
        let userRef = Ref().databaseSpecificUser(uid: chatPartnerUid)
        userRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dict = snapshot.value as? [String: Any] else {
                return
            }
            
            let user = User()
            user.uid = chatPartnerUid
            user.setValuesForKeys(dict)
            self.showChatLog(user: user)
        }, withCancel: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let message = messages[indexPath.row]
        if let chatPartnerUid = message.chatPartnerId() {
            Ref().databaseSpecificUserMessages(uid: uid).child(chatPartnerUid).removeValue { (error, ref) in
                if error != nil {
                    print("Failed to delete message: ", error!)
                    return
                }
                
                Ref().databaseSpecificUserMessages(uid: chatPartnerUid).child(uid).removeValue()

                self.messagesDictionary.removeValue(forKey: chatPartnerUid)
                self.attemptReloadOfCollection()
            }
        }
    }
}
