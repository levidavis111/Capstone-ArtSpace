//
//  FilterVC.swift
//  ArtSpaceDos
//
//  Created by God on 2/7/20.
//  Copyright © 2020 Jocelyn Boyd. All rights reserved.
//

import UIKit
import SnapKit
import Firebase

//MARK: Create a delegate for Filtering
class FilterViewController: UIViewController {
    private var filterArray = ["1", "2"]

    lazy var popUpView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .darkGray
        return view
    }()
    lazy var filterButtonOne: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "1"
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        addSubViews(all: [popUpView])
        setUpConstraints()
    }


    @objc func filterPosts() {
        loadPosts(tag: "1")
    }

    func loadPosts(tag: String){
        _ = [ArtObject]()
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            FirestoreService.manager.getPosts(forArtID: tag ?? "") { (result) in
                switch result {
                case .success(let artPieces):
                    self?.loadPostsHandleSuccess(with: artPieces)
                case .failure(let error):
                    print(":( \(error)")

                }
            }
        }
    }

    private func loadPostsHandleSuccess(with artObjects: [ArtObject]) {
        let mainVC = MainViewController()
        mainVC.artObjectData = artObjects
        mainVC.artCollectionView.reloadData()
    }
    
    func addSubViews(all views: [UIView]) {
        views.forEach({view.addSubview($0)})
    }

    func setUpConstraints() {
        popUpView.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(300)
        }
    }
//
}
//
//extension FilterViewController: UICollectionViewDelegate {
//
//}
//extension FilterViewController: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//       return filterArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "identifier", for: indexPath) as! MDCChipCollectionViewCell
//        cell.chipView.titleLabel.text = filterArray[indexPath.row]
//        cell.chipView.setTitleColor(UIColor.red, for: .selected)
//         cell.chipView.isUserInteractionEnabled = true
//        cell.chipView.addTarget(self, action: #selector(filterPosts), for: .touchUpInside)
//        return cell
//    }
//}
