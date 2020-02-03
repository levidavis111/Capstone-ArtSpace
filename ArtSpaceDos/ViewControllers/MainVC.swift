
//
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
    button.setImage(UIImage(systemName: "list.bullet"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .black
    button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
    return button
    }()
  
    lazy var userProfile: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "person"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
    button.tintColor = .black
    return button
    }()
    
    lazy var artCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    let cv = UICollectionView(frame:.zero , collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 250)
    cv.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    cv.register(ArtCell.self, forCellWithReuseIdentifier: "artCell")
    cv.delegate = self
    cv.dataSource = self
    return cv
    }()
    
    lazy var postButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "plus"), for: .normal)
    button.imageView?.contentMode = .scaleAspectFit
    button.tintColor = .black
    button.backgroundColor = .white
    button.imageEdgeInsets = UIEdgeInsets(top: 25,left: 25,bottom: 25,right: 25)
    button.addTarget(self, action: #selector(transitionToForm), for: .touchUpInside)
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
    //MARK: - UISetup
  
  private func addSubviews() {
      [filterButton, artCollectionView].forEach({self.view.addSubview($0)})
  }
  
  private func setupUIConstraints() {
 
    postButton.snp.makeConstraints { make in
         make.centerX.equalTo(view.snp.top)
        make.centerX.equalTo(view.snp.trailing)
//        make.top.equalToSuperview().offset(15)
//        make.right.equalTo(self.view).offset(50)
    }
    
//    userProfile.snp.makeConstraints { make in
//    make.top.equalTo(searchBar).offset(15)
//    make.left.equalTo(searchBar).offset(-50)
//    }
//
    artCollectionView.snp.makeConstraints { make in
        make.top.equalTo(postButton)
        make.left.equalTo(view).offset(10)
        make.bottom.equalTo(view).offset(10)
        make.right.equalTo(view).offset(10)
        
//        make.edges.equalTo(view).inset(UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//    make.top.equalTo(self.view).offset(150)
//    make.left.equalTo(self.view)
//    make.bottom.equalTo(self.view)
//    make.right.equalTo(self.view)
    }
    }
    
    //MARK: - Obj-C Functions
    @objc func transitionToForm() {
    let nextVC = CreatePost()
    self.navigationController?.pushViewController(nextVC, animated: true)
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
