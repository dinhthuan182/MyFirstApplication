//
//  SignInViewController+UI.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/8/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import Foundation
import UIKit

extension SignInViewController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setupTitleLabel() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let title = "Sign In"
        let attributeTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Baskerville-Bold", size: 35)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        signInLabel.attributedText = attributeTitle
    }
    
    func setupEmailTextField() {
        //custom emailView
        emailView.layer.borderWidth = 1
        emailView.layer.borderColor = UIColor.customRGB(210, 210, 210, 1).cgColor
        emailView.layer.cornerRadius = 6
        emailView.clipsToBounds = true

        //custom emailTextField
        emailTextField.borderStyle = .none
        let placeholderAttribute = NSAttributedString(string: "Email Address", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customRGB(170, 170, 170, 1)])
        emailTextField.attributedPlaceholder = placeholderAttribute
        emailTextField.textColor = UIColor.customRGB(170, 170, 170, 1)
    }
    
    func setupPasswordTextField() {
        //custom emailView
        passwordView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor.customRGB(210, 210, 210, 1).cgColor
        passwordView.layer.cornerRadius = 6
        passwordView.clipsToBounds = true

        //custom emailTextField
        passwordTextField.borderStyle = .none
        let placeholderAttribute = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customRGB(170, 170, 170, 1)])
        passwordTextField.attributedPlaceholder = placeholderAttribute
        passwordTextField.textColor = UIColor.customRGB(170, 170, 170, 1)
    }
    
    func setupSignInButton() {
        signInButton.layer.borderWidth = 1
        signInButton.layer.borderColor = UIColor.customRGB(210, 210, 210, 1).cgColor
        signInButton.layer.cornerRadius = 6
        signInButton.clipsToBounds = true
        signInButton.titleLabel?.text = "Sign In"
        signInButton.tintColor = .white
    }
    
    func setupFogotPasswordButton() {
        foGotPasswordButton.titleLabel?.text = "Fogot your Password?"
        foGotPasswordButton.tintColor = .white
    }
    
    func setupSignInOtherLabel() {
        signInOther.text = "------ Or Sign in With ------"
        signInOther.textColor = UIColor.customRGB(170, 170, 170, 1)
        signInOther.font = UIFont.systemFont(ofSize: 20)
    }
    
    func setupFacebookSignIn() {
        facebookSignInButton.setImage(UIImage(named: "facebook_color"), for: .normal)
        facebookSignInButton.imageView?.contentMode = .scaleAspectFit
        facebookSignInButton.tintColor = .white
        facebookSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        //facebookSignInButton.imageEdgeInsets = UIEdgeInsets(top: 12, left: -15, bottom: 12, right: 0)
    }
    
    func setupGoogleSignIn() {
        googleSignInButton.setImage(UIImage(named: "google_color"), for: .normal)
        googleSignInButton.imageView?.contentMode = .scaleAspectFit
        googleSignInButton.tintColor = .white
        googleSignInButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func setupSignUpButton() {
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.65)])
             
        let attributedTermsText = NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white])
             attributedText.append(attributedTermsText)
        
        signUpButton.setAttributedTitle(attributedText, for: .normal)
    }
}
