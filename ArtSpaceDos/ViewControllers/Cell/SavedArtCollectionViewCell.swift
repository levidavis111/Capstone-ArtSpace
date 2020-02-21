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
  
  //MARK: Properties
  var delegate: SavedArtCellDelegate?
  
  //MARK: UI Elements
  lazy var savedImageView: UIImageView = {
    let imageView = UIImageView()
    //MARK: Note: How to better scale pictures in view?
    imageView.contentMode = .scaleToFill
    imageView.backgroundColor = .clear
    return imageView
  }()
  
  lazy var bookmarkButton: UIButton = {
    let button = UIButton()
    let imageConfig = UIImage.SymbolConfiguration(scale: .large)
    button.setImage(UIImage(systemName: "bookmark.fill", withConfiguration: imageConfig), for: .normal)
    button.tintColor = .systemBlue
    button.layer.backgroundColor = UIColor.clear.cgColor
    button.addTarget(self, action: #selector(bookmarkButtonPressed), for: .touchUpInside)
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
  
  lazy var buyButton: UIButton = {
    let button = UIButton()
    button.setTitle("Buy", for: .normal)
    button.layer.backgroundColor = UIColor(red: 35/255, green: 46/255, blue: 33/255, alpha: 1).cgColor
    button.layer.borderWidth = 1.0
    button.layer.cornerRadius  = 5.0
    button.addTarget(self, action: #selector(buyButtonPressed), for: .touchUpInside)
    return button
  }()
  
  lazy var soldStatusView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    return view
  }()
  
  lazy var soldStatusLabel: UILabel = {
    let label = UILabel()
    label.text = "Item Sold"
    label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 75)
    label.textColor = .red
    return label
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
  @objc func bookmarkButtonPressed() {
    delegate?.removeSavedArt(tag: tag)
  }
  
  @objc func buyButtonPressed() {
    delegate?.buyButtonPressed(tag: tag)
  }
  
  //MARK: Functions
  func updateSoldStatus(status: Bool) {
    if status {
      setupSoldStatus()
    }
  }
  
  //MARK: Private Functions
  private func addSubViews() {
    contentView.addSubview(savedImageView)
    contentView.addSubview(bookmarkButton)
    contentView.addSubview(titleLabel)
    contentView.addSubview(artistNameLabel)
    contentView.addSubview(priceLabel)
    contentView.addSubview(buyButton)
  }
  
  private func setupSoldStatus() {
    contentView.addSubview(soldStatusView)
    soldStatusView.addSubview(soldStatusLabel)
    constrainSoldStatus()
    buyButton.isEnabled = false
    buyButton.isHidden = true
  }
  
  private func constrainSoldStatus() {
    soldStatusView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView)
      make.left.equalTo(contentView)
      make.right.equalTo(contentView)
      make.bottom.equalTo(contentView).offset(-75)
    }
    
    soldStatusLabel.snp.makeConstraints { (make) in
      make.center.equalTo(soldStatusView)
    }
    
  }
  
  private func addConstraints() {
    savedImageView.snp.makeConstraints { (make) in
      make.top.equalTo(contentView)
      make.left.equalTo(contentView)
      make.right.equalTo(contentView)
      make.bottom.equalTo(contentView).offset(-75)
    }
    
    bookmarkButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(savedImageView).offset(50)
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
      make.bottom.equalTo(savedImageView).offset(50)
      make.left.equalTo(bookmarkButton).offset(-75)
      make.width.equalTo(75)
    }
  }
  
}
