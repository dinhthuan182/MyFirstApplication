//
//  ChatApi.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/10/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class ChatApi {
    func sendMessage(message: String, toUser: User, onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        let messageValues = [CONTENT: message] as [String : Any]
        sendMessageWithProperties(properties: messageValues, toUser: toUser, onSucess: onSucess, onError: onError)
    }
    
    func sendMessageWithImage(imageUrl: String, image: UIImage, toUser: User, onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        let properties: [String: Any] = [IMAGEURL: imageUrl,
                                           IMAGEHEIGHT: image.size.height,
                                           IMAGEWIDTH: image.size.width]
        sendMessageWithProperties(properties: properties, toUser: toUser, onSucess: onSucess, onError: onError)
    }
    
    func sendMessageWithProperties(properties: [String: Any], toUser: User, onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        let chatRef = Ref().databaseAutoUidChats()
        let toUid = toUser.uid!
        let fromUid = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        var message = [TOUID: toUid,
                       FROMUID: fromUid,
                       TIMESTAMP: timestamp,
            ] as [String : Any]
        //append properties dictionary
        //key $0, $1
        properties.forEach({message[$0] = $1})
        
        chatRef.updateChildValues(message) { (error, ref) in
            if error != nil {
                onError(error! as! String)
                return
            }
            onSucess()
            let userMessagesRef = Ref().databaseSpecificUserMessages(uid: fromUid).child(toUid)
            let messageId = chatRef.key!
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Ref().databaseSpecificUserMessages(uid: toUid).child(fromUid)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
}
