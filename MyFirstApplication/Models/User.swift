//
//  User.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/13/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit

class User {
    var uid: String?
    var fullName: String
    var email: String
    var avatarUrl: String?
    
    init(uid: String, fullName: String, email: String, avatarUrl: String?) {
        self.fullName = fullName
        self.email = email
        if let url = avatarUrl {
            self.avatarUrl = url
        }
    }
}
