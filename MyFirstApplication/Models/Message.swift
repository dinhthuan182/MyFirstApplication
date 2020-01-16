//
//  Message.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/14/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth

class Message: NSObject {
    @objc var content: String?
    @objc var fromUid: String?
    @objc var timestamp: NSNumber?
    @objc var toUid: String?
    @objc var imageUrl: String?
    
    func chatPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
}
