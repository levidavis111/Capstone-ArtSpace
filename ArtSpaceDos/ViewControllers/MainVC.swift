

import UIKit
import SnapKit


class HomePageVC: UIViewController {
  
  //MARK: - Properties
  var artObjectData = [ArtObject]() {
    didSet {
      self.artCollectionView.reloadData()
    }
  }
  
  //MARK: - Variables
  lazy var filterButton: UIButton = {
    let button = UIButton()
    button.setTitle("Filter", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(transitionToFilterVC), for: .touchUpInside)
    button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
    return button
  }()
  
  lazy var artCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    let cv = UICollectionView(frame:.zero , collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 250)
    cv.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
    UIUtilities.setViewBackgroundColor(cv)
    cv.delegate = self
    cv.dataSource = self
    return cv
  }()
  
  lazy var createPost: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .black
    button.backgroundColor = .white
    button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
    button.addTarget(self, action: #selector(transitionToCreatePostVC), for: .touchUpInside)
    return button
  }()
  
  //MARK: -- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    UIUtilities.setViewBackgroundColor(view)
    addSubviews()
    setupUIConstraints()
    getArtPosts()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = true
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    self.navigationController?.navigationBar.isHidden = false
  }
  
  //MARK: - Obj-C Functions
  @objc func transitionToCreatePostVC() {
    let nextVC = CreatePost()
    self.navigationController?.pushViewController(nextVC, animated: true)
  }
  
  @objc func transitionToFilterVC() {
    //code here
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
          dump(artFromFirebase)
        }
      }
    }
  }
  
  //MARK: - UISetup Functions
  private func addSubviews() {
    [filterButton,createPost,artCollectionView].forEach({self.view.addSubview($0)})
  }
  
  private func setupUIConstraints() {
    createPost.snp.makeConstraints { make in
      make.top.equalTo(self.view).offset(50)
      make.right.equalTo(self.view).offset(-25)
    }
    
    filterButton.snp.makeConstraints { (make) in
      make.top.equalTo(self.view).offset(50)
      make.left.equalTo(self.view).offset(25)
    }
    
    artCollectionView.snp.makeConstraints { make in
      make.top.equalTo(createPost).offset(35)
      make.left.equalTo(self.view.safeAreaLayoutGuide)
      make.bottom.equalTo(self.view)
      make.right.equalTo(self.view.safeAreaLayoutGuide)
    }
  }
}

//MARK: -- Extensions
extension HomePageVC: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //    return arrayOfImages.count
    return artObjectData.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = artCollectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtCell else {return UICollectionViewCell()}
    
    let data = artObjectData[indexPath.row]
    ImageHelper.shared.getImage(urlStr: data.artImageURL) { (result) in
      DispatchQueue.main.async {
        switch result {
        case .failure(let error):
          print(error)
        case .success(let image):
          cell.imageView.image = image
        }
      }
    }
    cell.priceLabel.text = "$\(data.price)"
    return cell
  }
}


extension HomePageVC: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let detailVC = ArtDetailVC()
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension HomePageVC: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 200, height: 200)
  }
}
