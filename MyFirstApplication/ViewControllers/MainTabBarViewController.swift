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

//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        let time = formatter.string(from: date)
//        Api.chats.sendMessage(message: "Good mornig", receiver: "E24O3sYszVd6A1JZdm8oIJ1ed1R2", time: time, status: 0, onSucess: {
//            print("Send message success")
//        }, onError: { (errorMessage) in
//            print(errorMessage)
//        })
    }
    

}
