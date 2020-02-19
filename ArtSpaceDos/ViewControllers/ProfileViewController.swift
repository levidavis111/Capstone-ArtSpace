//
//  ProfileViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    //MARK: UI OBJC
    
    lazy var userLabels: UILabel = {
        let label = UILabel()
        return label
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
    


}
