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
    
    //add properties height and width for image
    @objc var imageUrl: String?
    @objc var imageHeight: NSNumber?
    @objc var imageWidth: NSNumber?
    
    //override init function
    init(dictionary: [String: AnyObject]) {
        super.init()
        content = dictionary["content"] as? String
        fromUid = dictionary["fromUid"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        toUid = dictionary["toUid"] as? String
        
        imageUrl = dictionary["imageUrl"] as? String
        imageHeight = dictionary["imageHeight"] as? NSNumber
        imageWidth = dictionary["imageWidth"] as? NSNumber
    }
    
    func chatPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
}
