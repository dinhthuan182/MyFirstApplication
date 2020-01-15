//
//  ReferenceDatabase.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Ref {
    //database reference
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    //users tree
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    //chats tree
    var databaseChats: DatabaseReference {
        return databaseRoot.child(REF_CHAT)
    }
    
    func databaseAutoUidChats() -> DatabaseReference {
        return databaseChats.childByAutoId()
    }
    
    func databaseSpecificChat(uid: String) -> DatabaseReference {
        return databaseChats.child(uid)
    }
    
    //user-messages tree
    var databaseUserMessages: DatabaseReference {
        return databaseRoot.child(REF_USER_MESSAGES)
    }
    
    func databaseSpecificUserMessages(uid: String) -> DatabaseReference {
        return databaseUserMessages.child(uid)
    }
    
    //storage reference
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(PROFILE_STORAGE)
    }
    
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
