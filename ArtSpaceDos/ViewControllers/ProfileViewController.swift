//
//  ProfileViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

        var photoLibraryAccess = false
    var image = UIImage() {
        didSet {
           profileImage.image = image
        }
    }

    
    //MARK: UI OBJC
    
   lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User Name"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .clear
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        return textField
    }()
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "1")
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        image.layer.borderWidth = 5.0
     var frame = image.frame
        frame.size.width = 200
        frame.size.height = 200
        image.frame = frame
   image.clipsToBounds = true
        image.layer.cornerRadius = image.frame.size.width/2
     return image
            }()
 
    lazy var addImageButton: UIButton = {
             let button = UIButton()
             button.setTitle("+", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
             button.titleLabel?.font = UIFont(name: "Verdana", size: 25)
             button.backgroundColor = .clear
             button.layer.cornerRadius = 5
             button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
             return button
         }()

    
    
    lazy var manageAccount: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue ,for: .normal)
        button.setTitle("Manage Account", for: .normal)
        button.backgroundColor = .clear
        button.titleLabel?.font = UIFont(name: "Verdana", size: 15)
        return button
    }()
    
    lazy var listingsLabel: UILabel = {
        let label = UILabel()
        label.text = "Listings"
        label.sizeToFit()
        return label
    }()
    
    lazy var purchasedListLabel: UILabel = {
        let label = UILabel()
        label.text = "Purchased"
        return label
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Settings", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana", size: 20)
        return button
    }()
    
    lazy var signOut: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Out", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Verdana", size: 15)
        return button
    }()
    
    //MARK: addSubviews
    func addSubviews() {
        view.addSubview(profileImage)
        view.addSubview(addImageButton)
        view.addSubview(manageAccount)
        view.addSubview(settingsButton)
        view.addSubview(signOut)
        view.addSubview(listingsLabel)
        view.addSubview(purchasedListLabel)
        view.addSubview(userNameTextField)
    }
    //MARK:ViewDidLoad cycle
    override func viewDidLoad() {
        super.viewDidLoad()
          addSubviews()
        constrainProfilePicture()
        constraintAddImage()
        constraintManageAccountLabel()
        settinglabelConstraints()
        signOutConstraints()
        listinglabelConstraints()
        purchasedlabelConstraints()
        setupUserNameTextField()
        
      self.navigationController?.navigationBar.isHidden = true
      UIUtilities.setViewBackgroundColor(view)
    }
    
//MARK: Objc Functions

 
     @objc private func addImagePressed() {
    let imagePickerViewController = UIImagePickerController()
      imagePickerViewController.delegate = self
      imagePickerViewController.sourceType = .photoLibrary
      
      if photoLibraryAccess {
          imagePickerViewController.delegate = self
          present(imagePickerViewController, animated: true, completion: nil)
      } else {
          let alertVC = UIAlertController(title: "No Access", message: "Camera access is required to use this app.", preferredStyle: .alert)
          alertVC.addAction(UIAlertAction (title: "Deny", style: .destructive, handler: nil))
          self.present(alertVC, animated: true, completion: nil)
          
          alertVC.addAction(UIAlertAction (title: "Camera Acess Allowed", style: .default, handler: { (action) in
              self.photoLibraryAccess = true
              self.present(imagePickerViewController, animated: true, completion: nil)
          }))
      }

         
     }
//
//    @objc func signOutFunc(){
//        FirebaseAuthService.manager.logoutUser()
//
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//            let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
//            else { return}
//
//        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {
//
//            window.rootViewController = LoginViewController()
//        }, completion: nil)
//    }
//
    
    private func presentPhotoPickerController() {
           DispatchQueue.main.async{
               let imagePickerViewController = UIImagePickerController()
               imagePickerViewController.delegate = self
               imagePickerViewController.sourceType = .photoLibrary
               imagePickerViewController.allowsEditing = true
               imagePickerViewController.mediaTypes = ["public.image"]
               self.present(imagePickerViewController, animated: true, completion: nil)
           }
       }

    //MARK: Constraints
    
    private func constrainProfilePicture() {
        profileImage.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(200)
            make.centerX.equalTo(self.view)
            make.height.equalTo(profileImage.frame.height)
            make.width.equalTo(profileImage.frame.width)

        }
    }
  
    private func constraintAddImage() {
          addImageButton.snp.makeConstraints { (make) in
              make.top.equalTo(self.view).offset(200)
            make.trailing.equalTo(self.view).offset(60)
            //  make.centerX.equalTo(self.view)
              make.size.equalTo(CGSize(width: 300, height: 300))
        }
      }
    
    private func constraintManageAccountLabel() {
        manageAccount.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(400)
            make.leading.equalTo(self.view).offset(50)
            make.trailing.equalTo(self.view).offset(-50)
            make.size.equalTo(CGSize(width: 100, height: 100))
            
        }
    }
    
    private func listinglabelConstraints() {
        listingsLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-350)
            make.leading.equalTo(self.view).offset(50)
            make.trailing.equalTo(self.view).offset(-50)
      
            }
    }
    private func purchasedlabelConstraints() {
         purchasedListLabel.snp.makeConstraints { (make) in
             make.bottom.equalTo(self.view).offset(-350)
            // make.leading.equalTo(self.view).offset(50)
           make.trailing.equalTo(self.view).offset(-50)
       
             }
     }
     
    
    private func settinglabelConstraints() {
        settingsButton.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.view).offset(-250)
    make.leading.equalTo(self.view).offset(50)
    make.trailing.equalTo(self.view).offset(-50)
    make.size.equalTo(CGSize(width: 100, height: 100))
                   
        }
    }
    private func signOutConstraints() {
        signOut.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-200)
            make.leading.equalTo(self.view).offset(50)
            make.trailing.equalTo(self.view).offset(-50)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
    }
    private func setupUserNameTextField() {
 
    }
    
    
}
//MARK: Extension
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            //couldn't get image :(
            return
        }
        self.image = image
        dismiss(animated: true, completion: nil)
    }
}
 

