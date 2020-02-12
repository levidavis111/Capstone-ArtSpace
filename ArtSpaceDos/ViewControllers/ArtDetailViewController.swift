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
//        imageView.image = #imageLiteral(resourceName: "noimage")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var dimensionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Size:"
        label.textColor = .black
        return label
    }()
    
    lazy var artistNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Artist Name: "
        return label
    }()
    
    lazy var priceNameLabel: UILabel = {
        let label = UILabel()
        label.text = "$$"
        return label
    }()
    //MARK: TO DO - Make arLogo a UIButton
        lazy var arLogo: UIImageView = {
            let Imagelogo = UIImageView()
            Imagelogo.image = #imageLiteral(resourceName: "ARKit-Badge")
            Imagelogo.translatesAutoresizingMaskIntoConstraints = false
           Imagelogo.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(arButtonTapped(_:)))
            Imagelogo.addGestureRecognizer(tapGesture)
            return Imagelogo
        }()
    
    lazy var buyNowButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.system)
        button.setTitle("BUY NOW ", for: .normal)
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
            self.navigationController?.pushViewController(newViewController, animated: true)
        }
        


    
    //MARK:- Private func
        private func getArtPosts() {
        priceNameLabel.text = "\(currentArtObject.price) Dollars"
        dimensionsLabel.text = "Height: \(currentArtObject.height) Width: \(currentArtObject.width)"
        artistNameLabel.text = currentArtObject.artistName
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
    }
    
    private func setupUIConstraints() {
        constrainDimensionLabel()
        constrainArtLabel()
        constrainPriceLabel()
        constrainBuyButton()
        constrainARButton()
        constrainArtView()
    }
    
    // MARK: - Constraints
    private func constrainDimensionLabel() {
        dimensionsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(150)
            make.top.equalToSuperview().offset(400)
            make.size.equalTo(CGSize(width: 400, height: 40))
        }
    }
    
    private func constrainArtLabel() {
        artistNameLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(150)
            make.top.equalToSuperview().offset(450)
            make.size.equalTo(CGSize(width: 400, height: 40))
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
            make.left.equalToSuperview().offset(150)
            make.top.equalToSuperview().offset(500)
            make.size.equalTo(CGSize(width: 400, height: 40))
        }
    }
    
    private func  constrainBuyButton() {
        buyNowButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(600)
            make.size.equalTo(CGSize(width: 350, height: 40))
        }
    }
    
    private func  constrainARButton() {
        arLogo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(650)
            make.size.equalTo(CGSize(width: 100, height: 50))
        }
    }
    
}


