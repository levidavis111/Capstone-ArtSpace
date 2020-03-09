//
//  ProfileViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import FirebaseAuth
import Photos
import Firebase

class ProfileViewController: UIViewController {
    
var unwrappedImageURL:URL!
var userName:String!
   var displayNameHolder = "Display Name"
    var defaultImage = UIImage(systemName: "1")
       
var settingFromLogin = false
var createUserModel:(email:String, password: String) = ("","")
var photoLibraryAccess = true
var currentUser: Result<User, Error>!
var userProfile: AppUser!
  
        var imageURL: URL? = nil
  var image = UIImage() {
    didSet {
      profileImage.image = image
    }
  }

    
  //MARK: UI OBJC
    lazy var displayName: UILabel = {
     let label = UILabel()
         label.textAlignment = .center
      label.text = "Welcome"
         return label
    }()
    
    lazy var profileImage: UIImageView = {
       let image = UIImageView()
     image.image = #imageLiteral(resourceName: "1")
       image.contentMode = .scaleAspectFill
       image.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
       image.layer.borderWidth = 5.0
      var frame = image.frame
       frame.size.width = 150
       frame.size.height = 150
       image.frame = frame
     image.clipsToBounds = true
       image.backgroundColor = .blue
       let gesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
       image.layer.cornerRadius = image.frame.size.width/2
       image.isUserInteractionEnabled = true
       image.addGestureRecognizer(gesture)
      return image
         }()
    
  


    lazy var editDisplayNameButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit Username", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(editDisplayNamePressed), for: .touchUpInside)
        return button
    }()
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter User Name"
        textField.font = UIFont(name: "Verdana", size: 14)
        textField.backgroundColor = .white
      //  textField.borderStyle = .bezel
        textField.layer.cornerRadius = 5
        textField.autocorrectionType = .no
        return textField
    }()
    
 
  lazy var uploadButton: UIButton = {
       let button = UIButton()
    button.setImage(UIImage(named: "icloud.and.arrow.up"), for: .normal)
     return button
     }()
  lazy var activityIndicator: UIActivityIndicatorView = {
       let activityView = UIActivityIndicatorView(style: .large)
       activityView.hidesWhenStopped = true
       activityView.color = .white
       activityView.stopAnimating()
       return activityView
   }()

  lazy var saveButton: UIButton = {
    let button = UIButton()
    button.setTitleColor(.black ,for: .normal)
    button.setTitle("Save Changes", for: .normal)
    button.backgroundColor = .clear
    button.titleLabel?.font = UIFont(name: "Verdana", size: 15)
    button.addTarget(self, action: #selector(updateButtonPressed), for: .touchUpInside)
        button.isEnabled = true
        button.isHidden = false
    return button
  }()
   

  lazy var settingsButton: UIButton = {
    let button = UIButton()
    button.setTitle("Settings", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Verdana", size: 15)
    return button
  }()
   lazy var paymentButton: UIButton = {
      let button = UIButton()
      button.setTitle("Change Payment", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.titleLabel?.font = UIFont(name: "Verdana", size: 15)
      return button
    }()
   
  //MARK: addSubviews
  func addSubviews() {
    view.addSubview(profileImage)
    view.addSubview(uploadButton)
    view.addSubview(saveButton)
    view.addSubview(settingsButton)
    view.addSubview(displayName)
    view.addSubview(paymentButton)
    view.addSubview(textField)
    view.addSubview(editDisplayNameButton)
  }
  //MARK:ViewDidLoad cycle
  override func viewDidLoad() {
    super.viewDidLoad()
     addSubviews()
    constrainProfilePicture()
    constraintAddImage()
    ConstraintsSignOut()
    settinglabelConstraints()
    PaymenlabelConstraints()
    constrainDisplayname()
    editUserNameConstraints()
    //textfieldConstraints()
   // textField.delegate = self
  



      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SignOut", style: .plain, target: self, action: #selector(signOutFunc))
   self.navigationController?.navigationBar.isHidden = false
 UIUtilities.setViewBackgroundColor(view)

  }
   
    

    
    
//MARK: Private Functions
    private func setSceneDelegateInitialVC(with result: Result<User, Error>) {
        DispatchQueue.main.async { [weak self] in
            switch result {
            case.success(let user):
                print(user)
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                    let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
                    else { return }
                
                if FirebaseAuthService.manager.currentUser != nil {
                    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromBottom, animations: {
                        window.rootViewController = MainTabBarController()
                    }, completion: nil)
                    
                } else {
                    print("No current user")
                }
                
                
            case .failure(let error):
                self?.showAlert(with: "Error Creating User", and: error.localizedDescription)
            }
            
        }
    }
    
    private func formValidation() {
           let validUserName = displayName.text != displayNameHolder
           let imagePresent = profileImage.image != defaultImage
           saveButton.isEnabled = validUserName && imagePresent
       }
    //MARK: Objc functions
  @objc func signOutFunc(){
    FirebaseAuthService.manager.logoutUser()

    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
      let sceneDelegate = windowScene.delegate as? SceneDelegate, let window = sceneDelegate.window
      else { return}

    UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromTop, animations: {

      window.rootViewController = LoginViewController()
    }, completion: nil)
  }

    @objc func SaveFunc() {
        
    }
    
    
    @objc private func profileImageTapped(){
        print("Pressed")
        
           switch PHPhotoLibrary.authorizationStatus() {
                   case .notDetermined, .denied, .restricted:
                       PHPhotoLibrary.requestAuthorization({[weak self] status in
                           switch status {
                           case .authorized:
                               self?.presentPhotoPickerController()
                           case .denied:
                               print("Denied photo library permissions")
                           default:
                               print("No usable status")
                           }
                       })
                   default:
                       presentPhotoPickerController()
                   }
    }
 
    
    private func presentPhotoPickerController() {
        DispatchQueue.main.async{
            let imagePickerViewController = UIImagePickerController()
            imagePickerViewController.delegate = self
            imagePickerViewController.sourceType = .photoLibrary
            imagePickerViewController.allowsEditing = true
            imagePickerViewController.mediaTypes = ["public.image", "public.movie"]
            self.present(imagePickerViewController, animated: true, completion: nil)
        }
    }
    
    @objc private func updateButtonPressed(){
        // guarding against not having a display name and image
//        guard let userName = displayName.text, let imageURL = imageURL else {
//            showAlert(with: "Error", and: "Please a valid image and user name")
//            return
//        }
        self.activityIndicator.startAnimating()
        FirestoreService.manager.updateCurrentUser(userName: userName) { (result) in
            switch (result) {
            case .success():
                self.activityIndicator.stopAnimating()
                self.showAlertWithSucessMessage()
            case .failure(let error):
                print(error)
            }
        }
      
        self.showAlert(with: "Error", and: "It seem your image was not save. Please check your image format and try again")
      
    }
    @objc func editDisplayNamePressed() {
          let alert = UIAlertController(title: "UserName", message: nil, preferredStyle: .alert)
          
          
          alert.addTextField { (textfield) in
              textfield.placeholder = "Enter UserName"
          }
          
          guard let userNameField = alert.textFields else {return}
          
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ (alert) -> Void in
              
            self.displayName.text = userNameField[0].text ?? self.displayNameHolder
              self.formValidation()
              
          }))
          
          present(alert, animated: true, completion: nil)
          
      }
    
    
    private func showAlert(with title: String, and message: String) {
         let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
         present(alertVC, animated: true, completion: nil)
     }
    
    
     private func showAlertWithSucessMessage(){
         let alert = UIAlertController(title: "Success", message: "You have updated your profile", preferredStyle: .alert)
         let ok = UIAlertAction(title: "OK", style: .default) { (dismiss) in
             self.handleNavigationAwayFromVCAfterUpdating()
         }
         alert.addAction(ok)
         present(alert, animated: true, completion: nil)
     }
    private func handleNavigationAwayFromVCAfterUpdating() {
          if settingFromLogin {
              self.dismiss(animated: true, completion: nil)
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
   private func constrainDisplayname() {
     displayName.snp.makeConstraints { (make) in
     //   make.top.greaterThanOrEqualTo(profileImage).offset(-50)
        make.top.equalTo(self.topLayoutGuide.snp.bottom)
        make.centerX.equalTo(self.view)
     }
   }
   
  private func constraintAddImage() {
     uploadButton.snp.makeConstraints { (make) in
       make.top.equalTo(self.view).offset(200)
      make.trailing.equalTo(self.view).offset(60)
       make.size.equalTo(CGSize(width: 50, height: 50))
    }
   }
   
  private func ConstraintsSignOut() {
    saveButton.snp.makeConstraints { (make) in
        make.bottom.equalTo(self.settingsButton).offset(80)
        make.leading.equalTo(self.view).offset(50)
       make.trailing.equalTo(self.view).offset(-50)
         
    }
  }
    

    private func editUserNameConstraints() {
        editDisplayNameButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.profileImage).offset(100)
            make.centerX.equalTo(self.view)
        }
    }
//    private func textfieldConstraints() {
//      textField.snp.makeConstraints { (make) in
//          make.centerY.equalTo(self.segmentedControl).offset(100)
//    make.leading.equalTo(self.view).offset(50)
//    make.trailing.equalTo(self.view).offset(-50)
//    make.size.equalTo(CGSize(width: 50, height: 50))
//
//      }
//    }
    private func PaymenlabelConstraints() {
        paymentButton.snp.makeConstraints { (make) in
            make.bottom.greaterThanOrEqualTo(self.editDisplayNameButton).offset(80)
           make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            
        }
    }
    private func settinglabelConstraints() {
      settingsButton.snp.makeConstraints { (make) in
        make.bottom.greaterThanOrEqualTo(self.paymentButton).offset(50)
      make.leading.equalTo(self.view)
          make.trailing.equalTo(self.view)
      }
    }

}

//https://firebasestorage.googleapis.com/v0/b/artspaceprototype.appspot.com/o/profilePicture%2F/(userID)?alt=media&token=edb656cf-aa8b-4b07-8c10-bb4d5108fc77


//MARK: Extension
extension ProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage = info[.editedImage] as? UIImage else {
            return
        }
        
        self.image = selectedImage
        
        guard let imageData = selectedImage.jpegData(compressionQuality: 0.7) else {
            return
        }
        
        FirebaseStorageService.manager.storeImage(pictureType: .profilePicture, image: imageData, completion: { [weak self] (result) in
                   switch result{
                   case .success(let url):
                    print("working")
                    print(result)
                       self?.imageURL = url
                    
                   case .failure(let error):
                    print("Notworking")
                       print(error)
                   }
               })
       self.activityIndicator.stopAnimating()
        picker.dismiss(animated: true, completion: nil)
    }
}

//extension ProfileViewController: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if let userName = textField.text {
//        displayName.text = "Welcome, \(userName)"
//        } else {
//            displayName.text = "Welcome"
//        }
//        return true
//    }
//}

