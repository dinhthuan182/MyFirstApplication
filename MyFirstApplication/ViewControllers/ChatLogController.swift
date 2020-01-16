//
//  ChatLogController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var containerViewBottomAnchor: NSLayoutConstraint?
    
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
    let uploadImageView = UIImageView()
    let sendButton = UIButton(type: .system)
    let separatorLineView = UIView()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .white
        self.collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        //self.collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        
        self.collectionView.keyboardDismissMode = .interactive

//        self.setupKeyboardObservers()
    }
    
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        containerView.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 60),
            sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        uploadImageView.isUserInteractionEnabled = true
        uploadImageView.image = UIImage(named: "image_icon")
        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(self.uploadImageView)
        NSLayoutConstraint.activate([
            uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            uploadImageView.widthAnchor.constraint(equalToConstant: 40),
            uploadImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        self.messageTextField.placeholder = "Enter message here ..."
        self.messageTextField.translatesAutoresizingMaskIntoConstraints = false
        self.messageTextField.delegate = self
        containerView.addSubview(self.messageTextField)
        
        NSLayoutConstraint.activate([
            self.messageTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8),
            self.messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            self.messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor),
            self.messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        ])
        
        separatorLineView.backgroundColor = .black
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLineView)
        
        NSLayoutConstraint.activate([
            separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor),
            separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            separatorLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
        return containerView
    }()
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            uploadImageToFirebaseUsingImage(image: imageSelected)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImageToFirebaseUsingImage(image: UIImage) {
        let imageName = NSUUID().uuidString
        let ref = Ref().storageSpecificMessageImages(imageName: imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { (metaData, error) in
                if error != nil {
                    print("Upload failure: ", error!)
                }
                
                ref.downloadURL { (url, erroe) in
                    if let metaImageUrl = url?.absoluteString {
                        Api.chats.sendMessageWithImage(imageUrl: metaImageUrl, toUser: self.user!, onSucess: {
                            print("send image success")
                        }) { (error) in
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    @objc func handleUploadTap() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.item]
        cell.textView.text = message.content
        
        setupCell(cell: cell, message: message)
        if let content = message.content {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: content).width + 27
            
        }
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
        
        //show image if message is a image
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingCacheWithUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].content {
            height = estimateFrameForText(text: text).height + 18
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
    }
}
