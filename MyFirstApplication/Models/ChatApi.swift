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
    func sendMessage(message: String, receiver: String, time: String, status: Int, onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        let messageDict: Dictionary<String, Any> = [
            SENDER_UID: Auth.auth().currentUser!.uid,
            MESSAGE: message,
            RECEIVER_UID: receiver,
            TIME: time,
            STATUS: status
        ]
        
        ReferenDatabase().databaseSpecificChat(uid: Auth.auth().currentUser!.uid).setValue(messageDict){ (error, ref) in
            if error == nil {
                onSucess()
            } else {
                onError(error!.localizedDescription)
            }
        }
    }
}
