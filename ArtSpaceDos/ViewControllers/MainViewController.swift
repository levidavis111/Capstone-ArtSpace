

import UIKit
import SnapKit
import Kingfisher

class MainViewController: UIViewController {
  
  //MARK: - Properties
  var artObjectData = [ArtObject]() {
    didSet {
      self.artCollectionView.reloadData()
    }
  }
  
  //MARK: - Variables
  lazy var artCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    let collectionView = UICollectionView(frame:.zero , collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 250)
    collectionView.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
    UIUtilities.setViewBackgroundColor(collectionView)
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()
  

  
  //MARK: -- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    UIUtilities.setViewBackgroundColor(view)
    addSubviews()
    setupUIConstraints()
    getArtPosts()
  }
  
  
  //MARK: - Obj-C Functions
  
  @objc func transitionToFilterVC() {
    let popUpVC = FilterViewController()
    popUpVC.modalPresentationStyle = .popover
    popUpVC.modalTransitionStyle = .crossDissolve
    self.navigationController?.present(popUpVC, animated: true, completion: nil)
  }
    
  
  //MARK: -- Private Functions
  private func getArtPosts() {
    FirestoreService.manager.getAllArtObjects { [weak self](result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let artFromFirebase):
        DispatchQueue.main.async {
          self?.artObjectData = artFromFirebase
        }
      }
    }
  }

    private func setupNavigationBar() {
       let title = "ArtSpace"
       let attrs = [
         NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
         NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Bold", size: 40)]
       navigationController?.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
       navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
       navigationController?.navigationBar.shadowImage = UIImage()
       navigationController?.navigationBar.isTranslucent = true
       navigationController?.view.backgroundColor = .clear
       navigationController?.navigationBar.topItem?.title = "\(title)"
        let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(transitionToFilterVC))
        self.navigationItem.leftBarButtonItem = filterButton
        
     }
  //MARK: - UISetup Functions
  private func addSubviews() {
    self.view.addSubview(artCollectionView)
  }
  
  private func setupUIConstraints() {
    artCollectionView.snp.makeConstraints { make in
        //MARK: TO DO revise constraints to super view
      make.top.equalTo(view).offset(100)
      make.left.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view)
      make.right.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

//MARK: -- Extensions
extension MainViewController: UICollectionViewDataSource {
//MARK: Research Diffable Data Source
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return artObjectData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = artCollectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtCell else {return UICollectionViewCell()}
    let currentImage = artObjectData[indexPath.row]
    let url = URL(string: currentImage.artImageURL)
    cell.imageView.kf.setImage(with: url)

    return cell
  }
}


extension MainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailVC = ArtDetailViewController()
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  //MARK: Fix Cell Size Across Simulators
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: 200)
  }
}


