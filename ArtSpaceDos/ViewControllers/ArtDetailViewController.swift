//
//  ArtDetailViewController.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 1/30/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ArtDetailViewController: UIViewController {
  
  //MARK: - Properties
  var currentImage: [UIImage]!
  
  // MARK: - UI Objects
    lazy var artImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "noimage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
  
  lazy var sizeName: UILabel = {
    let label = UILabel()
    label.text = "Size:"
    label.textColor = .black
    return label
  }()
  
  lazy var artistName: UILabel = {
    let label = UILabel()
    label.text = "Artist Name: "
    return label
  }()
  
  lazy var priceName: UILabel = {
    let label = UILabel()
    label.text = "$$"
    return label
  }()
  
  lazy var arLogo: UIImageView = {
    let Imagelogo = UIImageView()
    Imagelogo.image = #imageLiteral(resourceName: "2064275-200")
    Imagelogo.translatesAutoresizingMaskIntoConstraints = false
    return Imagelogo
  }()
  
  lazy var priceButton: UIButton = {
    let button = UIButton(type: UIButton.ButtonType.system)
    button.setTitle("BUY NOW ", for: .normal)
    button.addTarget(self, action: #selector(PriceTapped), for: .touchUpInside)
    view.addSubview(button)
    return button
  }()
  
  //MARK: - Obj-C Functions
  @objc func PriceTapped() {
    let alertPopup = UIAlertController(title: "Successful", message: "Thank you for your purchase!", preferredStyle: .alert)
    alertPopup.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
    self.present(alertPopup, animated: true, completion: nil)
  }
  
  //MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    self.navigationController?.navigationBar.isHidden = true
    UIUtilities.setViewBackgroundColor(view)
    addSubviews()
    setupUIConstraints()
  }
  
  //MARK: - Private functions
  private func addSubviews() {
    view.addSubview(artImage)
    view.addSubview(sizeName)
    view.addSubview(artistName)
    view.addSubview(priceName)
    view.addSubview(arLogo)
  }
  
  private func setupUIConstraints() {
   
    constSizelabel()
    constArtistlabel()
    constMoneyLabel()
    constBuyButton()
    constARButton()
    constImageView()
  }
  
  // MARK: - Constraints
 private func constSizelabel() {
    sizeName.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(150)
      make.top.equalToSuperview().offset(400)
      make.size.equalTo(CGSize(width: 400, height: 40))
    }
  }
  
  private func constArtistlabel() {
    artistName.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(150)
      make.top.equalToSuperview().offset(450)
      make.size.equalTo(CGSize(width: 400, height: 40))
    }
  }
  
    private func constImageView() {
        artImage.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 400, height: 300))
           
              }
    }
    
    
  private func constMoneyLabel() {
    priceName.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(150)
      make.top.equalToSuperview().offset(500)
      make.size.equalTo(CGSize(width: 400, height: 40))
    }
  }
  
  private func  constBuyButton() {
    priceButton.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(600)
      make.size.equalTo(CGSize(width: 350, height: 40))
    }
  }
  
  private func  constARButton() {
    arLogo.snp.makeConstraints { (make) in
      make.left.equalToSuperview().offset(20)
      make.top.equalToSuperview().offset(650)
      make.size.equalTo(CGSize(width: 100, height: 50))
    }
  }
  
}

extension ArtDetailViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 150, height: 200)
  }
  
}
//lazy var cancelButton: UIButton = {
//       let button = UIButton()
//       button.backgroundColor = .clear
//       button.tintColor = .black
//       button.setImage(UIImage(systemName: "xmark"), for: .normal)
//       button.imageView?.contentMode = .scaleAspectFit
//               button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
//       button.addTarget(self, action: #selector(transitionOut), for: .touchUpInside)
//       return button
//   }()
//
//   @objc func transitionOut() {
//       let prevVC = HomePageVC()
//       prevVC.modalPresentationStyle = .fullScreen
//       self.present(prevVC, animated: true, completion: nil)
//   }
//
//   cancelButton.snp.makeConstraints { make in
//                  make.width.equalTo(75)
//                  make.top.equalTo(self.view).offset(75)
//                  make.left.equalTo(self.view).offset(15)
//              }
