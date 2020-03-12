

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
  var currentFilters = [String]()
  var isCurrentlyFiltered = false
  
  let cellSpacing: CGFloat = 5.0
  
  //MARK: - Variables
  lazy var artCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    let collectionView = UICollectionView(frame:.zero , collectionViewLayout: layout)
    layout.scrollDirection = .vertical
    layout.itemSize = CGSize(width: 250, height: 250)
    collectionView.register(ArtCell.self, forCellWithReuseIdentifier: ReuseIdentifier.artCell.rawValue)
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    getArtPosts()
  }
  
  
  //MARK: - Obj-C Functions
  @objc func transitionToFilterVC() {
    let popUpVC = FilterViewController()
    popUpVC.modalPresentationStyle = .overCurrentContext
    popUpVC.modalTransitionStyle = .crossDissolve
    popUpVC.filterDelegate = self
    if isCurrentlyFiltered {
      popUpVC.tagArray = currentFilters
    } else {
      popUpVC.tagArray = [String]()
    }
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
    let filterButton = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(transitionToFilterVC))
    UIUtilities.setUpNavigationBar(title: "ArtSpace", viewController: self, leftBarButton: filterButton)
  }
  
  private func showAlert(with title: String, and message: String) {
    let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
    present(alertVC, animated: true, completion: nil)
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
    guard let cell = artCollectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier.artCell.rawValue, for: indexPath) as? ArtCell else {return UICollectionViewCell()}
    let currentImage = artObjectData[indexPath.row]
    let url = URL(string: currentImage.artImageURL)
    cell.imageView.kf.setImage(with: url)
    cell.delegate = self
    cell.likeButton.tag = indexPath.row
    
    let _ = currentImage.existsInFavorites { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let bool):
        switch bool {
        case true:
          cell.likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        case false:
          cell.likeButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
      }
    }
    return cell
  }
}


extension MainViewController: UICollectionViewDelegate {
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let specificArtObject = artObjectData[indexPath.row]
    //MARK: TO DO - Pass data of current cell to Detail View
    let detailVC = ArtDetailViewController()
    detailVC.currentArtObject = specificArtObject
    self.navigationController?.pushViewController(detailVC, animated: true)
  }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let numCells: CGFloat = 2
    let numSpaces: CGFloat = numCells + 1
    
    let screenWidth = UIScreen.main.bounds.width
    let screenheight = UIScreen.main.bounds.height
    
    return CGSize(width: (screenWidth - (cellSpacing * numSpaces)) / numCells, height: screenheight / 4)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: cellSpacing, left: cellSpacing, bottom: 0, right: cellSpacing)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return cellSpacing
  }
}

//MARK: To Do - Refactor So that the App doesnt have to call to Firebase to reset
extension MainViewController: FilterTheArtDelegate {
  func cancelFilters() {
    //Resets the filters by calling the original art objects from Firebase
    getArtPosts()
    isCurrentlyFiltered = false
  }
  
  func getTagsToFilter(get tags: [String]) {
    loadFilteredPosts(tags: tags)
    //Assigns the tags filtering the collection view to a variable that will be passed back to the Filtering View Controller
    currentFilters = tags
    //A bool that determines whether on not the view Controller is filtered, will be passed back to filter view controller so that the user doesnt repeat filters
    isCurrentlyFiltered = true
  }
  
  func loadFilteredPosts(tags: [String]) {
    //Checking to make sure that there are tags to be filtered
    guard tags.count > 0 else {
      showAlert(with: "Oops!", and: "Please select a filter!")
      //Resets All Art If There Is No Filter
      getArtPosts()
      return
    }
    //Filtering through the art object data based upon the tags selected
    artObjectData = artObjectData.filter({$0.tags.contains(tags[0].lowercased())
    })
  }
  
}

extension MainViewController: ArtCellFavoriteDelegate {
  //    MARK: - TODO: Update code to use Current User
  func faveArtObject(tag: Int) {
    let oneArtObject = artObjectData[tag]
    let _ = oneArtObject.existsInFavorites { (result) in
      switch result {
      case .failure(let error):
        print(error)
      case .success(let bool):
        switch bool {
        case true:
          FirestoreService.manager.removeSavedArtObject(artID: oneArtObject.artID) { (result) in
            switch result {
            case .failure(let error):
              print(error)
            case .success(()):
              print("You deleted that art from favorites")
            }
          }
        case false:
          FirestoreService.manager.createFavoriteArtObject(artObject: oneArtObject) { (result) in
            switch result {
            case .failure(let error):
              print(error)
            case .success(()):
              print("You saved that to favorites")
            }
          }
        }
      }
    }
  }
  
  
}

//MARK: - Note: Impelement function once user authorization is done 
/**
 extension ArtSearchViewController: EventCellDelegate {
     func faveEvent(tag: Int) {
         let oneArt = arts[tag]
         guard let user = FirebaseAuthService.manager.currentUser else {return}
         print("oneArt")
         let existsInFaves = oneArt.existsInFavorites { (result) in
             switch result {
             case .failure(let error):
                 print(error)
             case .success(let bool):
                 switch bool {
                 case true:
                     FirestoreService.manager.deleteFavoriteArt(forUserID: user.uid, artID: oneArt.id) { (result) in
                         switch result {
                         case .failure(let error):
                             print(error)
                         case .success(()):
                             print("You deleted that art from the search cell")
                         }
                     }
                 case false:
                     
                    let favedArt = FavoriteArt(title: oneArt.title, longTitle: oneArt.longTitle, principalOrFirstMaker: oneArt.principalOrFirstMaker, photoURL: oneArt.webImage?.url ?? "", id: oneArt.id, creatorID: user.uid)
                     
                     FirestoreService.manager.saveArt(art: favedArt) { (result) in
                         switch result {
                         case .failure(let error):
                             print(error)
                         case .success(()):
                             print("You saved that art from the search vc cell")
                         }
                     }
                 }
             }
         }
         
     }
     
 }
 */
