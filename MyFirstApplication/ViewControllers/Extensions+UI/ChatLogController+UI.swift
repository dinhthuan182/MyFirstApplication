//
//  ChatLogController+UI.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

extension ChatLogController {
    
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyBoardDidShow() {
        if messages.count > 0 {
            let indexPath = IndexPath(item: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
        }
    }
    
    @objc func handleKeyBoardWillShow(notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        containerViewBottomAnchor?.constant = -keyboardFrame.height
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyBoardWillHide(notification: NSNotification) {
        let keyboardDuration = (notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as! Double)
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func sendMessage() {
        let text = messageTextField.text!
        Api.chats.sendMessage(message: text, toUser: user!, onSucess: {
            self.messageTextField.text = nil
        }, onError: { (error) in
            print(error)
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessage()
        return true
    }
}

