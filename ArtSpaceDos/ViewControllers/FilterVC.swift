//
//  FilterVC.swift
//  ArtSpaceDos
//
//  Created by God on 2/7/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import MaterialComponents.MaterialChips
import SnapKit
import Firebase 
class FilterVC: UIViewController {
    private var filterArray = ["1", "2"]
    lazy var collectionView: UICollectionView = {
        let layout = MDCChipCollectionViewFlowLayout()
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(MDCChipCollectionViewCell.self, forCellWithReuseIdentifier: "identifier")
        cv.backgroundColor = .black
        cv.allowsMultipleSelection = true
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        setUpConstraints()
    }
    
    
    @objc func filterPosts() {
        let mainVC = HomePageVC()
        mainVC.artObjectData = loadPosts(tag: "1")
        mainVC.artCollectionView.reloadData()
    }
    
    func loadPosts(tag: String) -> [ArtObject] {
        var returnArt = [ArtObject]()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirestoreService.manager.getPosts(forArtID: tag ?? "") { (result) in
                switch result {
                case .success(let artPieces):
                    returnArt = artPieces
                case .failure(let error):
                    print(":( \(error)")
                    
                }
            }
        }
        return returnArt
    }
    
    
    func setUpConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            make.top.equalTo(view)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(view)
        }
    }
    

}

extension FilterVC: UICollectionViewDelegate {
    
}
extension FilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return filterArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
        cell.chipView.titleLabel.text = filterArray[indexPath.row]
        cell.chipView.setTitleColor(UIColor.red, for: .selected)
         cell.chipView.isUserInteractionEnabled = true
        cell.chipView.addTarget(self, action: #selector(filterPosts), for: .touchUpInside)
       
        return cell
    }
    
    
}
extension FilterVC {
    
    }
