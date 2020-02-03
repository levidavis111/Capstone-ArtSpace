

import UIKit
import SnapKit


class HomePageVC: UIViewController {
  
//MARK: - Properties
  var arrayOfImages = [UIImage(named: "1"),UIImage(named: "2"),UIImage(named: "3"),UIImage(named: "4"),UIImage(named: "5"),UIImage(named: "6"),UIImage(named: "7"),UIImage(named: "8"),UIImage(named: "9"),UIImage(named: "10")]
  
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
  
  lazy var optionsMenu: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    button.imageView?.contentMode = .scaleToFill
    button.layer.cornerRadius = 10
    button.backgroundColor = .white
    button.tintColor = .black
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
  private func addSubviews() {   [filterButton,createPost,optionsMenu,artCollectionView].forEach({self.view.addSubview($0)})
    view.bringSubviewToFront(optionsMenu)
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
        
        optionsMenu.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-50)
            make.right.equalTo(self.view).offset(-50)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        artCollectionView.snp.makeConstraints { make in
            make.top.equalTo(createPost).offset(35)
            make.left.equalTo(self.view)
            make.bottom.equalTo(self.view)
            make.right.equalTo(self.view)
        }
    }
}

//MARK: -- Extensions
extension HomePageVC: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return arrayOfImages.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = artCollectionView.dequeueReusableCell(withReuseIdentifier: "artCell", for: indexPath) as? ArtCell else {return UICollectionViewCell()}
    
    let currentImage = arrayOfImages[indexPath.row]
    cell.imageView.image = currentImage!
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
