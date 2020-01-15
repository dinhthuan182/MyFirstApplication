//
//  SignInViewController.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/8/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class SignInViewController: UIViewController {

    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var signInStackView: UIStackView!
    
    @IBOutlet weak var emailView: UIView!
    @IBOutlet weak var emailStackView: UIStackView!
    @IBOutlet weak var emailImage: UIImageView!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordStackView: UIStackView!
    @IBOutlet weak var passwordImage: UIImageView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var foGotPasswordButton: UIButton!
    @IBOutlet weak var signInOther: UILabel!
    
    
    @IBOutlet weak var otherSignInStackView: UIStackView!
    @IBOutlet weak var facebookSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "signInVCToMainTabBarVC", sender: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        self.setupTitleLabel()
        self.setupEmailTextField()
        self.setupPasswordTextField()
        self.setupSignInButton()
        self.setupFogotPasswordButton()
        self.setupSignInOtherLabel()
        self.setupFacebookSignIn()
        self.setupSignUpButton()
        self.setupGoogleSignIn()
    }
    @IBAction func signInButtonDidTapped(_ sender: Any) {
        self.view.endEditing(true)
        self.validateTextField()
        
        self.signIn(onSucess: {
            //Switch view
            self.performSegue(withIdentifier: "signInVCToMainTabBarVC", sender: nil)
            
        }, onError: { (errorMessage) in
            ProgressHUD.showError(errorMessage)
        })    }
    
    //check input of data:  email and password of user
    func validateTextField() {
        guard let email = self.emailTextField.text, !email.isEmpty else {
            ProgressHUD.showSuccess(ERROR_EMPTY_EMAIL)
            return
        }
        
        guard let password = self.passwordTextField.text, !password.isEmpty else {
            ProgressHUD.showSuccess(ERROR_EMPTY_PASSWORD)
            return
        }
    }
    
    func signIn(onSucess: @escaping() -> Void, onError: @escaping(_ errormessage: String) -> Void) {
        ProgressHUD.show()
        Api.users.signIn(email: self.emailTextField.text!, password: self.passwordTextField.text!, onSucess: {
            ProgressHUD.dismiss()
            onSucess()
        }, onError: { (errorMessage) in
            onError(errorMessage)
        })
    }
    
}
