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
    
    @objc var videoUrl: String?
    
    //override init function
    init(dictionary: [String: AnyObject]) {
        super.init()
        content = dictionary[CONTENT] as? String
        fromUid = dictionary[FROMUID] as? String
        timestamp = dictionary[TIMESTAMP] as? NSNumber
        toUid = dictionary[TOUID] as? String
        
        imageUrl = dictionary[IMAGEURL] as? String
        imageHeight = dictionary[IMAGEHEIGHT] as? NSNumber
        imageWidth = dictionary[IMAGEWIDTH] as? NSNumber
        
        videoUrl = dictionary[VIDEOURL] as? String
    }
    
    func chatPartnerId() -> String? {
        return fromUid == Auth.auth().currentUser?.uid ? toUid : fromUid
    }
}
