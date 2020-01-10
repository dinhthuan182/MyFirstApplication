//
//  SignUpViewController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/8/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import ProgressHUD

class SignUpViewController: UIViewController {

    @IBOutlet weak var signUpTitleLabel: UILabel!
    
    @IBOutlet weak var signUpStackView: UIStackView!
    
    @IBOutlet weak var avatarStackView: UIStackView!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var fullNameView: UIView!
    @IBOutlet weak var fullNameStackView: UIStackView!
    @IBOutlet weak var fullNameImage: UIImageView!
    @IBOutlet weak var fullNameTextField: UITextField!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signInButton: UIButton!
    
    var avatar: UIImage? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    func setupUI() {
        self.setupTitleLabel()
        self.setupAvatarImage()
        self.setupFullNameTextField()
        self.setupEmailTextField()
        self.setupPasswordTextField()
        self.setupSignInButton()
        self.setupSignUpButton()
    }
    
    //click button Sign Up to register account
    @IBAction func signUpButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateInput()
        self.signUpAccount(onSuccess: {
            //switch view
            self.performSegue(withIdentifier: "signupVCToMainTabBarVC", sender: nil)
        }, onError: { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        })
    }
    
    //check input of data: full name, email and password of user
    func validateInput() {
        guard let fullName = self.fullNameTextField.text, !fullName.isEmpty else {
            ProgressHUD.showSuccess(ERROR_EMPTY_FULLNAME)
            return
        }
        
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showSuccess(ERROR_EMPTY_EMAIL)
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showSuccess(ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    func signUpAccount(onSuccess: @escaping() -> Void, onError: @escaping(_ errorMessage: String) -> Void) {
        ProgressHUD.show()
        Api.users.signUp(fullName: self.fullNameTextField.text!, email: self.emailTextField.text!, password: self.passwordTextField.text!, avatar: self.avatar, onSuccess: {
            ProgressHUD.dismiss()
            onSuccess()
        }){ (errorMessage) in
            onError(errorMessage)
        }
    }
    
}
