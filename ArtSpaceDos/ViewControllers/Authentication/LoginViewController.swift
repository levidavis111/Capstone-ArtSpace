//
//  LoginViewController.swift
//  ArtSpaceDos
//
//  Created by God on 2/18/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import SnapKit
import FirebaseAuth

class LoginViewController: UIViewController {

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
    
    lazy var loginButton: UIButton = {
        let button = UIButton(frame:CGRect(x: 0, y: 0, width: 250, height: 40))
        UIUtilities.setUpButton(button, title: "Login", backgroundColor:  #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1) , target: self, action: #selector(loginUserFunction))
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
        UIUtilities.setUpButton(button, title: "Don't Have An Account?", backgroundColor: .clear, target: self, action: #selector(switchToSignUpController))
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
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
    UIUtilities.addSubViews([gifView,titleLabel,emailTextField,passwordTextField,loginButton,switchToLogin], parentController: self)
        setUpConstraints()
    }
    //MARK: Objective C
    @objc func loginUserFunction() {
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
        
        FirebaseAuthService.manager.loginUser(email: email.lowercased(), password: password) { (result) in
            self.handleLoginAccountResponse(with: result)
        }
        
        
        
    }
    
    @objc func switchToSignUpController() {
           let signUpViewController = SignUpViewController()
        signUpViewController.modalPresentationStyle = .overFullScreen
           self.present(signUpViewController, animated: true, completion: nil)
       }
    
    //MARK: Private Function
    private func handleLoginAccountResponse(with result: Result<(), Error>) {
        DispatchQueue.main.async {
            switch result {
            case .failure(let error):
                self.showAlert(with: "Error", and: "Could not log in. Error: \(error)")
            case .success:
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate
                    else {
                        return
                }
                UIView.transition(with: self.view, duration: 0.1, options: .transitionFlipFromBottom, animations: {
                  let mainViewController = MainTabBarController()
                    mainViewController.modalPresentationStyle = .overCurrentContext
                    sceneDelegate.window?.rootViewController = mainViewController
                }, completion: nil)
            }
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
        
        passwordTextField.snp.makeConstraints{ make in
            make.top.equalTo(emailTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(titleLabel).offset(100)
            make.height.equalTo(40)
        }

        loginButton.snp.makeConstraints{ make in
            make.top.equalTo(passwordTextField).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
        switchToLogin.snp.makeConstraints{ make in
            make.top.equalTo(loginButton).offset(100)
            make.centerX.equalTo(view)
            make.width.equalTo(250)
            make.height.equalTo(40)
        }
        
    
    }
}
