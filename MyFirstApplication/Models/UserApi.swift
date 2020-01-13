//
//  UserApi.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import ProgressHUD

class UserApi {
    func signIn(email: String, password: String,onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (authData, error) in
            if error != nil {
                onError(error!.localizedDescription)
                return
            }
            print("User: \(authData!.user.uid)")
            onSucess()
        })
    }
    
    func signUp(fullName: String, email: String, password: String, avatar: UIImage?, onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) -> Void {
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            if let authData = authDataResult {
                let dict: Dictionary<String, Any> = [
                    UID: authData.user.uid,
                    EMAIL: authData.user.email!,
                    FULLNAME: fullName,
                    PROFILE_IMAGE_URL: "",
                    STATUS: "Welcome to ChatApp"
                ]
                
                guard let imageSelected = avatar else {
                    ProgressHUD.showError(ERROR_EMPTY_PHOTO)
                    return
                }
                
                guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {
                    return
                }
                
                let storageProfile = ReferenDatabase().storageSpecificProfile(uid: authData.user.uid)
                let metaData = StorageMetadata()
                metaData.contentType = "image/jpg"
                
                StorageService.savePhoto(email: email, uid: authData.user.uid, data: imageData, metaData: metaData, storageProfileRef: storageProfile, dict: dict, onSuccess: {
                    onSuccess()
                }, onError: {(errorMessage) in
                    onError(errorMessage)
                })
            }
        }
    }
}
