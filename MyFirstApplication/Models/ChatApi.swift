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
    func sendMessage(message: Message, onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        let receiverDict: Dictionary<String, Any> = [
            UID: message.receiver.uid ?? "K8EnGbfGOdeaqqtjxz9RzAEiie52",
            FULLNAME: message.receiver.fullName,
            PROFILE_IMAGE_URL: message.receiver.avatarUrl ?? "https://firebasestorage.googleapis.com/v0/b/chatapp-8f79c.appspot.com/o/profiles%2FK8EnGbfGOdeaqqtjxz9RzAEiie52?alt=media&token=57c51b5c-357e-4d09-a937-87c5b1cfe986"
        ]
        
        ReferenDatabase().databaseSpecificUser(uid: Auth.auth().currentUser!.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let senderDict: Dictionary<String, Any> = [
                UID: Auth.auth().currentUser!.uid,
                FULLNAME: value?[FULLNAME] as! String,
                PROFILE_IMAGE_URL: value?[PROFILE_IMAGE_URL] as! String
            ]
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let created = formatter.string(from: message.createdAt)
            let messageDict: Dictionary<String, Any> = [
                SENDER: senderDict,
                TEXT: message.text,
                RECEIVER: receiverDict,
                CREATED_AT: created,
                STATUS: message.status
            ]
            let node = "\(Auth.auth().currentUser!.uid)_\(receiverDict[UID] ?? "E24O3sYszVd6A1JZdm8oIJ1ed1R2")"
            ReferenDatabase().databaseSpecificChat(uid: node).childByAutoId().setValue(messageDict){ (error, ref) in
                if error == nil {
                    onSucess()
                } else {
                    onError(error!.localizedDescription)
                }
            }
        }) { (error) in
            onError(error.localizedDescription)
        }
    }
    
    func loadAllMessage(onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        //ReferenDatabase.loadAllMessage(currentUid: Auth.auth().currentUser?.uid)
    }
}
