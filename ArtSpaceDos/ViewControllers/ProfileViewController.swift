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
    
    lazy var userLabels: UILabel = {
        let label = UILabel()
        return label
    }()
    lazy var profileImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "profileIcon")
        image.contentMode = .scaleAspectFill
        image.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        image.layer.cornerRadius = 100
               return image
            }()
 
    lazy var addImageButton: UIButton = {
             let button = UIButton()
             button.setTitle("Edit", for: .normal)
             button.setTitleColor(.purple, for: .normal)
             button.titleLabel?.font = UIFont(name: "Verdana-Bold", size: 12)
             button.backgroundColor = .clear
             button.layer.cornerRadius = 5
             button.addTarget(self, action: #selector(addImagePressed), for: .touchUpInside)
             return button
         }()

    
    
    lazy var manageAccount: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var listingsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var purchasedListLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var signOut: UIButton = {
        let button = UIButton()
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
