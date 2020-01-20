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
    // database reference
    let databaseRoot: DatabaseReference = Database.database().reference()
    
    // users
    var databaseUsers: DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    // users/uid
    func databaseSpecificUser(uid: String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    // messages
    var databaseChats: DatabaseReference {
        return databaseRoot.child(REF_MESSAGE)
    }
    
    // messages/autoID
    func databaseAutoUidChats() -> DatabaseReference {
        return databaseChats.childByAutoId()
    }
    
    // messages/uid
    func databaseSpecificChat(uid: String) -> DatabaseReference {
        return databaseChats.child(uid)
    }
    
    // user-messages
    var databaseUserMessages: DatabaseReference {
        return databaseRoot.child(REF_USER_MESSAGES)
    }
    
    // user-messages/uid
    func databaseSpecificUserMessages(uid: String) -> DatabaseReference {
        return databaseUserMessages.child(uid)
    }
    
    // storage reference
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    
    // profiles
    var storageProfile: StorageReference {
        return storageRoot.child(PROFILE_STORAGE)
    }
    
    // profiles/uid
    func storageSpecificProfile(uid: String) -> StorageReference {
        return storageProfile.child(uid)
    }
    
    // message-images
    var storegeMessageImages: StorageReference {
        return storageRoot.child(MESSAGE_IMAGES_STORAGE)
    }
    
    // message-images/imageName
    func storageSpecificMessageImages(imageName: String) -> StorageReference {
        return storegeMessageImages.child(imageName)
    }
    
    // message-movies
    var storageMessageMovies: StorageReference {
        return storageRoot.child(MESSAGE_MOVIE_STORAGE)
    }
    
    // message-movies/fileName
    func storageSpecificMessageMovies(fileName: String) -> StorageReference {
        return storageMessageMovies.child(fileName)
    }
}
