//
//  FavoritesViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/6/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit

class SavedArtViewController: UIViewController {

  var arrayOfImages = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6"),UIImage(named: "7"),UIImage(named: "8"),UIImage(named: "9"),UIImage(named: "10")]
  
  lazy var savedArtCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .vertical
    layout.sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    
    let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 200, height: 200), collectionViewLayout: layout)
    collection.register(SavedArtCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier.savedArtCell.rawValue)
    collection.dataSource = self
    collection.delegate = self
    
    collection.layer.backgroundColor = UIColor.clear.cgColor
       collection.layer.shadowColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
       collection.layer.shadowOffset = CGSize(width: 0, height: 1.0)
       collection.layer.shadowOpacity = 0.9
       collection.layer.shadowRadius = 4
    
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
    let viewControllerTitle = "Saved Art List"
    let attrs = [
      NSAttributedString.Key.foregroundColor: UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1),
      NSAttributedString.Key.font: UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 25)]
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
//    savedArtCollectionView.translatesAutoresizingMaskIntoConstraints = false
    
    savedArtCollectionView.snp.makeConstraints { (make) in
      make.top.equalTo(view.safeAreaLayoutGuide)
      make.left.equalTo(view.safeAreaLayoutGuide)
      make.bottom.equalTo(view.safeAreaLayoutGuide)
      make.right.equalTo(view.safeAreaLayoutGuide)
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
    return arrayOfImages.count
  }
  
  //MARK: TODO - Pass data from Firebase 
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = savedArtCollectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.savedArtCell.rawValue, for: indexPath) as? SavedArtCollectionViewCell else {return UICollectionViewCell()}
    cell.savedImageView.image = arrayOfImages[indexPath.row]
//           let currentImage = artObjectData[indexPath.row]
//           let url = URL(string: currentImage.artImageURL)
//           cell.imageView.kf.setImage(with: url)
    
           return cell
  }
  
  
}

extension SavedArtViewController: UICollectionViewDelegate {
  
}
