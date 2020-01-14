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
    }

}


