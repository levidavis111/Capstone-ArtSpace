//
//  SignUpViewController.swift
//  ArtSpaceDos
//
//  Created by God on 2/18/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    //MARK: UI Elements
    lazy var gifView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage.gif(asset: "artSpace")
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "ArtSpace", size: 0, alignment: .center)
        label.font = UIFont(name: "Chalkduster", size: 40)
        label.textColor = .white
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Email", alignment: .center)
        input.backgroundColor = .white
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        return input
    }()
    
    lazy var usernameInputView: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Username", alignment: .center)
        input.backgroundColor = .white
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        return input
    }()
    
    lazy var passwordTextField: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Enter Password", alignment: .center)
        input.backgroundColor = .white
        input.isSecureTextEntry = true
        input.alpha = 0.90
        input.layer.cornerRadius = 10.0
        input.clipsToBounds = true
        return input
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 250, height: 40))
        UIUtilities.setUpButton(button, title: "Sign Up", backgroundColor: #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), target: self, action: #selector(signUpUser))
        button.titleLabel?.textColor = .red
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    lazy var switchToLogin: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 250, height: 40))
        UIUtilities.setUpButton(button, title: "Already Have An Account?", backgroundColor: .clear, target: self, action: #selector(switchToLoginController))
        button.layer.cornerRadius = button.frame.height / 2
        button.clipsToBounds = true
        button.layer.shadowOffset = CGSize(width: 2, height: 2)
        button.layer.shadowColor = UIColor.darkGray.cgColor
        button.layer.masksToBounds = false
        button.layer.shadowOpacity = 0.5
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationController?.navigationBar.isHidden = true
        UIUtilities.addSubViews([gifView,titleLabel,emailTextField,usernameInputView,passwordTextField,signUpButton,switchToLogin], parentController: self)
        setUpConstraints()
    }
    //MARK: Objective C
    @objc func signUpUser() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            showAlert(with: "Error", and: "Please fill out all fields.")
            return
        }
        
        guard email.isValidEmail else {
            showAlert(with: "Error", and: "Please enter a valid email")
            return
        }
        
        guard password.isValidPassword else {
            showAlert(with: "Error", and: "Please enter a valid password. Passwords must have at least 8 characters.")
            return
        }
        
        FirebaseAuthService.manager.createNewUser(email: email.lowercased(), password: password) { [weak self] (result) in
            self?.handleCreateAccountResponse(with: result)
        }
    }
    
    @objc func switchToLoginController() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .overFullScreen
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    //MARK: Private Function
    private func handleCreateAccountResponse(with result: Result<User, Error>) {
        DispatchQueue.main.async {
            switch result {
            case .success(let user):
                FirestoreService.manager.createAppUser(user: AppUser(from: user)) { [weak self] newResult in
                    self?.handleCreatedUserInFirestore(result: newResult)
                }
            case .failure(let error):
                self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
            }
        }
    }
    
    private func handleCreatedUserInFirestore(result: Result<Void, Error>) {
        switch result {
        case .success:
            let tabBarController = MainTabBarController()
            tabBarController.modalPresentationStyle = .overCurrentContext
            self.present(tabBarController, animated: true, completion: nil)
        case .failure(let error):
            self.showAlert(with: "Error creating user", and: "An error occured while creating new account \(error)")
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - Constraints
    
    func setUpConstraints() {
        gifView.snp.makeConstraints{ make in
            make.height.equalTo(view)
            make.width.equalTo(view).offset(100)
        }
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(view).offset(50)
            make.centerX.equalTo(view)
            
        }
        
        emailTextField.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel).offset(150)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        }
        
        usernameInputView.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        }

        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(usernameInputView).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        
        }
        
        signUpButton.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        switchToLogin.snp.makeConstraints{ make in
            make.top.equalTo(signUpButton).offset(50)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(60)
        }
    }
}
