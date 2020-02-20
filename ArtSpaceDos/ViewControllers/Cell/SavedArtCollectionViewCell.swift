//
//  SavedArtCollectionViewCell.swift
//  ArtSpaceDos
//
//  Created by Jocelyn Boyd on 2/19/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import SnapKit

class SavedArtCollectionViewCell: UICollectionViewCell {
  
  //MARK: UI Elements
  lazy var savedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "7")
    imageView.contentMode = .scaleToFill
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  lazy var favoriteButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(scale: .large)
    button.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig), for: .normal)
    button.tintColor = .red
    button.layer.backgroundColor = UIColor.clear.cgColor
//    button.layer.borderColor = UIColor.black.cgColor
//    button.layer.borderWidth = 1
//    button.layer.cornerRadius = 23.0
    button.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Title"
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption1), size: 16)
    label.textColor = .black
    return label
  }()
  
  lazy var artistNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Artist"
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption1), size: 16)
    label.textColor = .black
    return label
  }()
  
  lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.text = "Price"
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .caption1), size: 16)
    label.textColor = .black
    return label
  }()
  
  //MARK: TODO - segue to detail view controller ->  launch Stripe ?
  lazy var buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Buy", for: .normal)
    button.layer.backgroundColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
    button.layer.borderWidth = 1.0
    button.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
    return button
  }()
  
  //MARK: Lifecycle Methods
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubViews()
    addConstraints()
    contentView.backgroundColor = UIColor(red: 255/255, green: 193/255, blue: 207/255, alpha: 1)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: Objc Functions
  @objc func heartButtonPressed() {
    //TODO: make an alert for to confirm of the user wants to delete the art from their list
    //TODO: delete favorite from list
  }
  
  @objc func buyButtonPressed() {
    //TODO: segue to Detail View Controller or Stripe ???
  }
  
  //MARK: Private functions
  private func addSubViews() {
    contentView.addSubview(savedImageView)
    contentView.addSubview(favoriteButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(artistNameLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(buyButton)
    
  }
  
  private func addConstraints() {
    savedImageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView)
      make.left.equalTo(contentView)
      make.right.equalTo(contentView)
      make.bottom.equalTo(contentView).offset(-75)
    }
    
    favoriteButton.snp.makeConstraints { (make) in
      make.top.equalTo(contentView).offset(10)
      make.right.equalTo(contentView).offset(-10)
      make.height.equalTo(45)
      make.width.equalTo(45)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(savedImageView).offset(25)
      make.left.equalTo(contentView).offset(25)
    }
    
    artistNameLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(titleLabel).offset(25)
      make.left.equalTo(contentView).offset(25)
    }
    
    priceLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(artistNameLabel).offset(25)
      make.left.equalTo(contentView).offset(25)
    }
    
    buyButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(savedImageView).offset(55)
      make.right.equalTo(contentView).offset(-25)
      make.width.equalTo(75)
    }
    
  }
  
}
