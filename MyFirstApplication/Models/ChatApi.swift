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
        let chatRef = Ref().databaseAutoUidChats()
        let toUid = toUser.uid!
        let fromUid = Auth.auth().currentUser!.uid
        let timestamp: NSNumber = NSNumber(value: NSDate().timeIntervalSince1970)
        let message = [CONTENT: message,
                       TOUID: toUid,
                       FROMUID: fromUid,
                       TIMESTAMP: timestamp
            ] as [String : Any]

        chatRef.updateChildValues(message) { (error, ref) in
            if error != nil {
                onError(error! as! String)
                return
            }
            onSucess()
            let userMessagesRef = Ref().databaseSpecificUserMessages(uid: fromUid)
            let messageId = chatRef.key!
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Ref().databaseSpecificUserMessages(uid: toUid)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
    }
}
