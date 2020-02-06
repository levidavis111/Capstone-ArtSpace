//
//  MainTabVC.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class MainTabVC: UITabBarController {
  
  //MARK: Properties
  lazy var homePage = UINavigationController(rootViewController: HomePageVC())
  lazy var profile = UINavigationController(rootViewController: ProfileVC())
  lazy var purchaseHistory = UINavigationController(rootViewController: PurchaseHistoryVC())
  lazy var favorites = UINavigationController(rootViewController: FavoritesVC())
  
  
    override func viewDidLoad() {
        super.viewDidLoad()
      setTabItems()
        // Do any additional setup after loading the view.
    }
    
  override func viewWillAppear(_ animated: Bool) {
     self.navigationController?.navigationBar.isHidden = true
   }
   
   override func viewWillDisappear(_ animated: Bool) {
     self.navigationController?.navigationBar.isHidden = false
   }
  
  private func setTabItems() {
    homePage.tabBarItem = UITabBarItem(title: "Main", image: UIImage(systemName: "house"), tag: 0)
    profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 1)
    favorites.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.circle"), tag: 2)
    purchaseHistory.tabBarItem = UITabBarItem(title: "History", image: UIImage(systemName: "dollarsign.circle"), tag: 3)
    
    self.viewControllers  = [homePage, profile, favorites, purchaseHistory]
    self.tabBar.barStyle = .default
    
  }

}
