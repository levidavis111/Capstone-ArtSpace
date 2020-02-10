//
//  MainTabVC.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {
  
  //MARK: Properties
  lazy var homePage = UINavigationController(rootViewController: MainViewController())
  lazy var createPost = UINavigationController(rootViewController: CreatePostViewController())
  lazy var favorites = UINavigationController(rootViewController: FavoritesViewController())
  lazy var profile = UINavigationController(rootViewController: ProfileViewController())
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setTabItems()
  }
  
  private func setTabItems() {
    homePage.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house.fill"), tag: 0)
    createPost.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus"), tag: 1)
    favorites.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "suit.heart"), tag: 2)
    profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 3)
    
    self.viewControllers  = [homePage, createPost, favorites, profile]
  }
}
