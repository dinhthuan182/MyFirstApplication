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

class ReferenDatabase {
    //Database Reference
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    //User Table
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    //Chat table
    var databaseChats: DatabaseReference {
        return databaseRoot.child(REF_CHAT)
    }
    
    func databaseSpecificChat(uid: String) -> DatabaseReference {
        return databaseChats.child(uid)
    }
    
    //Storage Reference
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    var storageProfile: StorageReference {
        return storageRoot.child(PROFILE_STORAGE)
    }
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
