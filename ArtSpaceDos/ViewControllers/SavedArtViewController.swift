//
//  FavoritesViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class SavedArtViewController: UIViewController {

  lazy var savedArtCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)
    collection.register(SavedArtCollectionViewCell.self, forCellWithReuseIdentifier: "SavedArtCell")
    collection.backgroundColor = .lightGray
    collection.dataSource = self
    collection.delegate = self
    return collection
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViewBackgroundColor()
    setupNavigationBar()
    setupSavedArtCollectionView()
  }
  
  private func setupViewBackgroundColor() {
    UIUtilities.setViewBackgroundColor(view)
  }
  
  private func setupNavigationBar() {
    let viewControllerTitle = "My List"
    let attrs = [
      NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
      NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Bold", size: 30)]
    navigationController?.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.isTranslucent = true
    navigationController?.view.backgroundColor = .clear
    navigationController?.navigationBar.topItem?.title = "\(viewControllerTitle)"
  }
  //MARK: TODO: Make an alert to confirm if the user wants to delete from their saved list

  private func setupSavedArtCollectionView() {
    view.addSubview(savedArtCollectionView)
    savedArtCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    savedArtCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view).offset(100)
      make.left.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view)
      make.right.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
  
}

extension SavedArtViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 25
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width - 50, height: view.safeAreaLayoutGuide.layoutFrame.width - 50)
  }
}

extension SavedArtViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     guard let cell = savedArtCollectionView.dequeueReusableCell(withReuseIdentifier: "SavedArtCell", for: indexPath) as? SavedArtCollectionViewCell else {return UICollectionViewCell()}
//           let currentImage = artObjectData[indexPath.row]
//           let url = URL(string: currentImage.artImageURL)
//           cell.imageView.kf.setImage(with: url)
           
           return cell
  }
  
  
}

extension SavedArtViewController: UICollectionViewDelegate {
  
}
