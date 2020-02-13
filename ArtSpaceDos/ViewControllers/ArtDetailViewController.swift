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
    var currentArtObject: ArtObject!
    
    // MARK: - UI Objects
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        UIUtilities.setUpImageView(imageView, image: UIImage(imageLiteralResourceName: "noimage"), contentMode: .scaleAspectFit)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var artDescription: UITextView = {
         let summary = UITextView()
         summary.textAlignment = .center
         summary.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
         summary.text = "Description Unavailable"
         summary.font = summary.font?.withSize(20)
         return summary
     }()
    
    lazy var dimensionsLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "Size", size: 20, alignment: .center)
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 20, alignment: .center)
        return label
    }()
    
    lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "", size: 20, alignment: .center)
        return label
    }()

        lazy var arLogo: UIImageView = {
            let Imagelogo = UIImageView()
            UIUtilities.setUpImageView(Imagelogo, image: #imageLiteral(resourceName: "ARKit-Badge"), contentMode: .scaleAspectFit)
           Imagelogo.backgroundColor = #colorLiteral(red: 0.4900177717, green: 0.5300267935, blue: 0.5836209655, alpha: 0.8659605369)
            Imagelogo.translatesAutoresizingMaskIntoConstraints = false
           Imagelogo.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arButtonTapped(_:)))
            Imagelogo.addGestureRecognizer(tapGesture)
            return Imagelogo
        }()
    
    lazy var buyNowButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        UIUtilities.setUpButton(button, title: "BUY NOW", backgroundColor: .clear, target: self, action: #selector(buyNowButtonPressed))
        button.setTitle("BUY NOW ", for: .normal)
       button.layer.cornerRadius = 15
         button.layer.borderWidth = 5.0
        button.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.addTarget(self, action: #selector(buyNowButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        return button
    }()
    
 
    //MARK: - Obj-C Functions
    @objc func buyNowButtonPressed() {
        let alertPopup = UIAlertController(title: "Successful", message: "Thank you for your purchase!", preferredStyle: .alert)
        //MARK: Go back to originalVC(Home)
        alertPopup.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        self.present(alertPopup, animated: true, completion: nil)
    }
    // MARK: arButtonNavigation
    @objc func arButtonTapped(_ tapGesture: UITapGestureRecognizer) {
        let newViewController = ARViewController()
        newViewController.artObject = self.currentArtObject
        self.navigationController?.pushViewController(newViewController, animated: true)
    }
    
    
    
    
    //MARK:- Private func
    private func getArtPosts() {
        priceNameLabel.text = "Price: $\(currentArtObject.price)"
        dimensionsLabel.text = "Size: H x \(currentArtObject.height) W x \(currentArtObject.width)D"
        artistNameLabel.text = "Artist: \(currentArtObject.artistName)"
         let url = URL(string: currentArtObject.artImageURL)
        artImageView.kf.setImage(with: url)
        
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //   self.navigationController?.navigationBar.isHidden = true
        UIUtilities.setViewBackgroundColor(view)
        addSubviews()
        setupUIConstraints()
        getArtPosts()
        
    }
    
    //MARK: - Private functions
    //MARK: TO DO - Pass data into the UI elements
    private func addSubviews() {
        view.addSubview(artImageView)
        view.addSubview(dimensionsLabel)
        view.addSubview(artistNameLabel)
        view.addSubview(priceNameLabel)
        view.addSubview(arLogo)
        view.addSubview(artDescription)
    }
    
    private func setupUIConstraints() {
        constrainDimensionLabel()
        constrainArtLabel()
        constrainPriceLabel()
        constrainBuyButton()
        constrainARButton()
        constrainArtView()
        descriptionConstraints()
    }
    
    // MARK: - Constraints
    private func constrainDimensionLabel() {
        dimensionsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.center.equalTo(view.center)
            make.top.equalToSuperview().offset(550)
            make.size.equalTo(CGSize(width: 450, height: 40))
        }
    }
    private func constrainArtLabel() {

        artistNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.center.equalTo(view.center)
            make.top.equalToSuperview().offset(600)
            make.size.equalTo(CGSize(width: 450, height: 40))
        }
        
    }
    
    private func constrainArtView() {
        artImageView.snp.makeConstraints{ (make) in
            make.left.equalToSuperview().offset(20)
           make.top.equalToSuperview().offset(100)
            make.size.equalTo(CGSize(width: 400, height: 300))

        }
    }

    
    private func constrainPriceLabel() {
     
        priceNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(100)
            make.center.equalTo(view.center)
            make.top.equalToSuperview().offset(650)
            make.size.equalTo(CGSize(width: 400, height: 40))
        }
    }
    
    private func  constrainBuyButton() {

        buyNowButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(150)
            make.top.equalToSuperview().offset(700)
            make.size.equalTo(CGSize(width: 125, height: 40))
        }
    }
    
    private func  constrainARButton() {
        arLogo.snp.makeConstraints { make in
            make.top.equalTo(buyNowButton.snp.bottom).offset(600)
            make.center.equalTo(view)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }

    }
    
    private func descriptionConstraints() {
  artDescription.snp.makeConstraints { (make) in
    make.center.equalTo(view.center)
       make.top.equalToSuperview().offset(500)
       make.size.equalTo(CGSize(width: 300, height: 40))
   }
        
    }
    
}


