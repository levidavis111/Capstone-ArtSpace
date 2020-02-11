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

//MARK: Filter Delegate
//NOTE: If more delegates need to be created add to a seperate file
protocol FilterTheArtDelegate: UIViewController {
    func getTagsToFilter(get tags:[String])
    func cancelFilters()
}

class FilterViewController: UIViewController {
    //MARK: Variables
    weak var filterDelegate: FilterTheArtDelegate?
    
    var tagArray = [String]()
    //MARK: UI Elements
    lazy var popUpView: UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = .white
        return view
    }()
    lazy var filterButtonOne: UIButton = {
        let button = UIButton()
        button.setTitle("1", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(addOrRemoveTags(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var filterButtonTwo: UIButton = {
        let button = UIButton()
        button.setTitle("2", for: .normal)
        button.backgroundColor = .lightGray
        button.addTarget(self, action: #selector(addOrRemoveTags(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Filter", for: .normal)
        button.backgroundColor = .lightGray
        button.isUserInteractionEnabled = true
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(filterPosts), for: .touchUpInside)
        return button
    }()
    
    lazy var resetPostsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reset", for: .normal)
        button.backgroundColor = .lightGray
        button.isUserInteractionEnabled = true
        button.showsTouchWhenHighlighted = true
        button.addTarget(self, action: #selector(resetPosts), for: .touchUpInside)
        return button
    }()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ifAlreadyFiltered(filterButtons: [filterButtonOne,filterButtonTwo])
        view.backgroundColor = UIColor.black.withAlphaComponent(0.50)
        view.isOpaque = false
        addSubViews(all: [popUpView,continueButton,resetPostsButton,filterButtonOne,filterButtonTwo])
        setUpConstraints()
    }
    
    //MARK: Private Functions
    func ifAlreadyFiltered(filterButtons: [UIButton]) {
        filterButtons.forEach({
            if tagArray.contains($0.titleLabel!.text!) {
                $0.backgroundColor = .darkGray
                $0.isSelected = true
            }
            else {
                $0.backgroundColor = .lightGray
                $0.isSelected = false
            }
        })
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    //MARK: Objective C Functions
    //MARK: TO DO - Account for when button has already been selected
    @objc func addOrRemoveTags(_ sender: UIButton) {
        if sender.isSelected {
            sender.backgroundColor = .lightGray
            //MARK: To Do - Be able to remove tag if there's multiple filters
            guard tagArray.count > 0 else {
                return
            }
            tagArray.remove(at: 0)
        }
        else {
            guard tagArray.contains(sender.titleLabel!.text!) else {
                tagArray.append(sender.titleLabel!.text!)
                sender.backgroundColor = .darkGray
                print(tagArray)
                return
            }
        }
    }
    @objc func dismissFilterVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func filterPosts() {
        filterDelegate?.getTagsToFilter(get: tagArray)
        dismissFilterVC()
    }
    @objc func resetPosts() {
        filterDelegate?.cancelFilters()
        dismissFilterVC()
    }
    
    //MARK: Constraints
    func addSubViews(all views: [UIView]) {
        views.forEach({view.addSubview($0)})
    }
    
    func setUpConstraints() {
        
        filterButtonOne.snp.makeConstraints { make in
            make.top.equalTo(popUpView).offset(50)
            make.left.equalTo(popUpView).offset(50)
            make.width.equalTo(75)
        }
        
        filterButtonTwo.snp.makeConstraints{ make in
            make.top.equalTo(popUpView).offset(50)
            make.right.equalTo(popUpView).inset(50)
            make.width.equalTo(75)
        }
        
        resetPostsButton.snp.makeConstraints { make in
            make.bottom.equalTo(popUpView)
            make.width.equalTo(150)
            make.right.equalTo(popUpView)
            make.height.equalTo(50)
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(popUpView)
            make.width.equalTo(150)
            make.left.equalTo(popUpView)
            make.height.equalTo(50)
        }
        
        popUpView.snp.makeConstraints{ make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.height.equalTo(300)
            make.width.equalTo(300)
        }
    }


}
