//
//  SignUpViewController+UI.swift
//  MyFirstApplication
//
//  Created by Catalina on 1/8/20.
//  Copyright © 2020 Catalina. All rights reserved.
//

import UIKit
import ProgressHUD

extension SignUpViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setupTitleLabel() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        let title = "Sign Up"
        let attributeTitle = NSMutableAttributedString(string: title, attributes: [
            NSAttributedString.Key.font: UIFont(name: "Baskerville-Bold", size: 35)!,
            NSAttributedString.Key.foregroundColor: UIColor.white
        ])
        signUpTitleLabel.attributedText = attributeTitle
    }
    
    func setupAvatarImage() {
        avatarImage.layer.cornerRadius = 60
        avatarImage.clipsToBounds = true
        avatarImage.isUserInteractionEnabled = true
        let tapGuesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        avatarImage.addGestureRecognizer(tapGuesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func setupFullNameTextField() {
        //custom emailView
        fullNameView.layer.borderWidth = 1
        fullNameView.layer.borderColor = UIColor.customRGB(210, 210, 210, 1).cgColor
        fullNameView.layer.cornerRadius = 6
        fullNameView.clipsToBounds = true

        //custom emailTextField
        fullNameTextField.borderStyle = .none
        let placeholderAttribute = NSAttributedString(string: "Full Name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.customRGB(170, 170, 170, 1)])
        fullNameTextField.attributedPlaceholder = placeholderAttribute
        fullNameTextField.textColor = UIColor.customRGB(170, 170, 170, 1)
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
    
    func setupSignUpButton() {
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.customRGB(210, 210, 210, 1).cgColor
        signUpButton.layer.cornerRadius = 6
        signUpButton.clipsToBounds = true
        signUpButton.titleLabel?.text = "Sign Up"
        signUpButton.tintColor = .white
    }
    
    func setupSignInButton() {
        let attributedText = NSMutableAttributedString(string: "Have an account? ", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(white: 1, alpha: 0.65)])
             
        let attributedTermsText = NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor: UIColor.white])
             attributedText.append(attributedTermsText)
        
        signInButton.setAttributedTitle(attributedText, for: .normal)
    }
}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            avatar = imageSelected
            avatarImage.image = imageSelected
        }
        
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            avatar = imageOriginal
            avatarImage.image = imageOriginal
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}


