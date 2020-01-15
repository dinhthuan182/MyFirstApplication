//
//  ChatLogController+UI.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

extension ChatLogController {
    func setupInputComponents() {
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
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
        
        messageTextField.placeholder = "Enter message here ..."
        messageTextField.translatesAutoresizingMaskIntoConstraints = false
        messageTextField.delegate = self
        containerView.addSubview(messageTextField)
        
        NSLayoutConstraint.activate([
            messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            messageTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor),
            messageTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor)
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
