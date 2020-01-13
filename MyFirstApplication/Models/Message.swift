//
//  Message.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/13/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation

class Message {
    var sender = User(uid: "", fullName: "", email: "", avatarUrl: "")
    var text: String
    var receiver: User
    var createdAt: Date
    var status: Int 
    
    init(text: String, receiver: User, createdAt: Date) {
        self.text = text
        self.receiver = receiver
        self.createdAt = createdAt
        self.status = 0
    }

}
