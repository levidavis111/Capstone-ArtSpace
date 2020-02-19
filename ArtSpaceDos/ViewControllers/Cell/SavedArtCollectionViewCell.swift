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
  
  lazy var savedImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "noimage")
    imageView.backgroundColor = .green
    return imageView
  }()
  
  //MARK: TODO - Implement function to unfavorite saved art and remove from view
  lazy var favoriteButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(scale: .large)
    button.setImage(UIImage(systemName: "heart.fill", withConfiguration: imageConfig), for: .normal)
    button.layer.backgroundColor = UIColor.white.cgColor
    button.layer.cornerRadius = 20.0
    //    button.addTarget(self, action: #selector(heartButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Title of Artwork"
    label.textColor = .white
    return label
  }()
  
  lazy var artistNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Artist Name"
    label.textColor = .white
    return label
  }()
  
  lazy var priceLabel: UILabel = {
    let label = UILabel()
    label.text = "Price"
    label.textColor = .white
    return label
  }()
  
  //MARK: TODO - segue to detail view controller ->  launch Stripe ?
  lazy var buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Buy", for: .normal)
    button.backgroundColor = .white
    button.layer.backgroundColor = UIColor.black.cgColor
    button.layer.borderWidth = 1.0
    //    button.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
    return button
  }()
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubViews()
    addConstraints()
    contentView.backgroundColor = .blue
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
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
      make.top.equalTo(contentView).offset(25)
      make.right.equalTo(contentView).offset(-25)
      make.height.equalTo(45)
      make.width.equalTo(45)
    }
    
    titleLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(savedImageView).offset(25)
      make.left.equalTo(contentView).offset(10)
    }
    
    artistNameLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(titleLabel).offset(25)
      make.left.equalTo(contentView).offset(10)
    }
    
    priceLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(artistNameLabel).offset(25)
      make.left.equalTo(contentView).offset(10)
    }
    
    buyButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(savedImageView).offset(55)
      make.right.equalTo(contentView).offset(-10)
      make.width.equalTo(100)
    }
    
  }
  
}
