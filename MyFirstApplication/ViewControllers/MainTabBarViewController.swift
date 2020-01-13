//
//  MainTabBarViewController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/9/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarViewController: UITabBarController { 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Auth.auth().currentUser == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signInVC = storyboard.instantiateViewController(withIdentifier: "SignInViewController")
            self.present(signInVC, animated: true, completion: nil)
        }
        let r = User(uid: "K8EnGbfGOdeaqqtjxz9RzAEiie52", fullName: "Thuan 1", email: "thuan1@gmail.com", avatarUrl: "https://firebasestorage.googleapis.com/v0/b/chatapp-8f79c.appspot.com/o/profiles%2FK8EnGbfGOdeaqqtjxz9RzAEiie52?alt=media&token=57c51b5c-357e-4d09-a937-87c5b1cfe986")
        let meesage = Message(text: "Xin chao buoi sang", receiver: r, createdAt: Date())

        Api.chats.sendMessage(message: meesage, onSucess: {
            print("Send message success")
        }, onError: { (errorMessage) in
            print(errorMessage)
        })
    }

}


