//
//  StorageService.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import ProgressHUD

class StorageService {
    static func savePhoto(email: String, uid: String, data: Data, metaData: StorageMetadata, storageProfileRef: StorageReference, dict: Dictionary<String, Any>, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        storageProfileRef.putData(data, metadata: metaData) { (storageMetaData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            storageProfileRef.downloadURL() { (url, error) in
                if let metaImageUrl = url?.absoluteString {
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.photoURL = url
                        changeRequest.displayName = email
                        changeRequest.commitChanges() { (error) in
                            if error != nil {
                                ProgressHUD.showError(error?.localizedDescription)
                            }
                        }
                    }
                    
                    //Update url avatar image of user
                    var dictNew = dict
                    dictNew[PROFILE_IMAGE_URL] = metaImageUrl
                    
                    ReferenDatabase().databaseSpecificUser(uid: uid).updateChildValues(dictNew){ (error, ref) in
                        if error == nil {
                            onSuccess()
                        } else {
                            onError(error!.localizedDescription)
                        }
                    }
                }
            }
        }
    }
}
