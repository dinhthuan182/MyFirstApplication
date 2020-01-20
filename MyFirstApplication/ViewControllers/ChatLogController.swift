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
import MobileCoreServices
import AVFoundation

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var containerViewBottomAnchor: NSLayoutConstraint?

    let cellId = "cellId"
    let containerView = UIView()
    let messageTextField = UITextField()
    let uploadImageView = UIImageView()
    let sendButton = UIButton(type: .system)
    let separatorLineView = UIView()
    
    var messages = [Message]()
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var startingImageView: UIImageView?
    
    var user: User? {
        didSet {
            navigationItem.title = user?.fullName
            observeMessages()
        }
    }
    
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
                
                let message = Message(dictionary: messageDict)
                if message.chatPartnerId() == self.user?.uid {
                    self.messages.append(message)
                    
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        //scroll to the last index
                        let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
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

        self.setupKeyboardObservers()
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
        
        if let videoUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            // selected video
            uploadVideoSelectedForUrl(url: videoUrl)
        } else if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            // selected image
            uploadImageToFirebaseUsingImage(image: imageSelected) { (metaImageUrl) in
                Api.chats.sendMessageWithImage(imageUrl: metaImageUrl, image: imageSelected, toUser: self.user!, onSucess: {
                    print("send image success")
                }) { (error) in
                    print(error)
                }
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadVideoSelectedForUrl(url: URL) {
        // auto create name for video
        let fileName = NSUUID().uuidString + ".mov"
        let storageRef = Ref().storageSpecificMessageMovies(fileName: fileName)
        
        let data = NSData(contentsOf: url)
        
        let uploadTask = storageRef.putData(data! as Data, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Failed upload of video: ", error!)
                return
            }
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    print("failed upload of video: ", error!)
                    return
                }

                if let storageUrl = url?.absoluteString {
                    print("Firebase link: ", storageUrl)
                    if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url!) {
                        self.uploadImageToFirebaseUsingImage(image: thumbnailImage) { (metaImageUrl) in
                            let properties: [String: Any] = [IMAGEURL: metaImageUrl,
                                                             VIDEOURL: storageUrl,
                                                             IMAGEWIDTH: thumbnailImage.size.width,
                                                             IMAGEHEIGHT: thumbnailImage.size.height]

                            Api.chats.sendMessageWithProperties(properties: properties, toUser: self.user!, onSucess: {
                                print("send video success")
                            }) { (error) in
                                print(error)
                            }
                        }
                    }
                }
            }
            
        }

        //update the upload process to navigation
        uploadTask.observe(.progress) { (snaphot) in
            if let completedUnitCount = snaphot.progress?.completedUnitCount {
                self.navigationItem.title = String(completedUnitCount)
            }
        }

        uploadTask.observe(.success) { (snapshot) in
            self.navigationItem.title = self.user?.fullName
        }
    }
    
    func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let err{
            print(err)
        }
        return nil
    }
    
    func uploadImageToFirebaseUsingImage(image: UIImage, completion: @escaping(_ imageUrl: String) -> ()) {
        let imageName = NSUUID().uuidString
        let ref = Ref().storageSpecificMessageImages(imageName: imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { (metaData, error) in
                if error != nil {
                    print("Upload failure: ", error!)
                }
                
                ref.downloadURL { (url, erroe) in
                    if let metaImageUrl = url?.absoluteString {
                        completion(metaImageUrl)
//                        Api.chats.sendMessageWithImage(imageUrl: metaImageUrl, image: image, toUser: self.user!, onSucess: {
//                            print("send image success")
//                        }) { (error) in
//                            print(error)
//                        }
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
        picker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
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
        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.content
        
        setupCell(cell: cell, message: message)
        if let content = message.content {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: content).width + 27
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            //fall in here if its an image message
            cell.bubbleWidthAnchor?.constant = 200
            cell.textView.isHidden = true
        }
        
        cell.playButton.isHidden = message.videoUrl == nil
        
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
        let message = messages[indexPath.item]
        if let text = message.content {
            height = estimateFrameForText(text: text).height + 18
        } else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue {
            height = CGFloat(imageHeight / imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
    }
    
    //custom zooming logic
    func performZoomInForImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        // get frame of image message
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomOut)))
        
        //if let keyWindow = UIApplication.shared.keyWindow {
        if let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first {
            keyWindow.endEditing(true)
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            keyWindow.addSubview(blackBackgroundView!)
            
            keyWindow.addSubview(zoomingImageView)
            //hidden input area when show image
            self.inputContainerView.alpha = 0
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackBackgroundView?.alpha = 1
                let height = self.startingFrame!.height / self.startingFrame!.width * keyWindow.frame.width
                
                zoomingImageView.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                zoomingImageView.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    @objc func handleZoomOut(tapGuesture: UITapGestureRecognizer) {
        if let zoomOutImageView = tapGuesture.view {
            //need to animate back out to contronler
            zoomOutImageView.layer.cornerRadius = 16
            zoomOutImageView.layer.masksToBounds = true
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                zoomOutImageView.frame = self.startingFrame!
                self.blackBackgroundView?.alpha = 0
                self.inputContainerView.alpha = 1
            }) { (completed: Bool) in
                //remove image after zoom
                zoomOutImageView.removeFromSuperview()
                self.startingImageView?.isHidden = false
            }
        }
    }
}
