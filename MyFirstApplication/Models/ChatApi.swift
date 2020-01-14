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
    }
    
    func loadAllMessage(onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        //let message = ReferenDatabase().loadAllMessage()
    }
}
