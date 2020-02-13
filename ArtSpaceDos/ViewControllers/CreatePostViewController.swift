
import UIKit
import SnapKit
import Photos
import AssetsLibrary

class CreatePostViewController: UIViewController {
    
    //MARK: - Properties
    var image = UIImage() {
        didSet {
            self.artImageView.image = image
        }
    }
    
    var imageURL: URL? = nil
    
    //MARK: - UIOjbects
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        UIUtilities.setUpButton(button, title: "", backgroundColor: .clear, target: self, action: #selector(pickPhoto))
        return button
    }()
    
    lazy var postArtLabel: UILabel = {
        let label = UILabel()
        UIUtilities.setUILabel(label, labelTitle: "Post Your Art Here", size: 20, alignment: .center)
        return label
    }()
    lazy var artTitleLabel: UITextField = {
        let input = UITextField()
        UIUtilities.setupTextView(input, placeholder: "Name Of Art", alignment: .center)
        return input
    }()
    
    lazy var artPriceLabel: UITextField = {
        let price = UITextField()
        UIUtilities.setupTextView(price, placeholder: "Price", alignment: .center)
        return price
    }()
    
    lazy var postButton: UIButton = {
        let button = UIButton()
        UIUtilities.setUpButton(button, title: "Post", backgroundColor: .darkGray, target: self, action: #selector(postArtToFirebase))
        return button
    }()
    
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        UIUtilities.setUpImageView(imageView, image: #imageLiteral(resourceName: "noimage"), contentMode: .scaleAspectFit)
        return imageView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        UIUtilities.setViewBackgroundColor(view)
        addSubviews()
        setUpConstraints()
    }
    
    
  
  //MARK: - Obj-C Functions
  @objc func transitionOut() {
    navigationController?.popToRootViewController(animated: true)
  }
  
  @objc func postArtToFirebase() {
    showAlert(with: "Art Posted", and: "Now available for Sale!")
    createArtObject()
  }
  
  @objc func pickPhoto() {
    let imagePickerVC = UIImagePickerController()
    imagePickerVC.delegate = self
    present(imagePickerVC, animated: true)
  }
    
    //    MARK: - Private Functions
    private func createArtObject(){
        guard let photoURL = imageURL else {return}
        let photoURLString = "\(photoURL)"
//        MARK: - TODO: implement real user once auth is implemented
//        guard let user = FirebaseAuthService.manager.currentUser else {return}
        let userID = "ABC123"
        
        let newArtObject = ArtObject(artistName: "Steve", artDescription: "Posted Art", width: 0.3, height: 0.2, artImageURL: photoURLString, sellerID: userID, price: 250.0, tags: ["2"])
        
        FirestoreService.manager.createArtObject(artObject: newArtObject) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(()):
                self.showAlert(with: "Art Posted", and: "Now Available For Sale!")
            }
        }
    }
    
    private func showAlert(with title: String, and message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(alert: UIAlertAction!) in
            let prevVC = MainViewController()
            prevVC.modalPresentationStyle = .fullScreen
            self.present(prevVC, animated: true, completion: nil)
        }))
        present(alertVC, animated: true, completion: nil)
    }
    
    private func setupNavigationBar() {
      let title = "Create Post"
      let attrs = [
        //MARK: TO DO - Get right font Avenir Next
        //MARK: To Do - Move navigation configurations to UI Utilities
        NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
        NSAttributedString.Key.font: UIFont(name: "SnellRoundhand-Bold", size: 40)]
      navigationController?.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
      navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
      navigationController?.navigationBar.shadowImage = UIImage()
      navigationController?.navigationBar.isTranslucent = true
      navigationController?.view.backgroundColor = .clear
      navigationController?.navigationBar.topItem?.title = "\(title)"
    }
    
    //MARK: UISetup
    func addSubviews() {
        [postArtLabel, artImageView, artPriceLabel,artTitleLabel, postButton,  uploadButton].forEach({self.view.addSubview($0)})
    }
    
    //MARK: TO DO - Fix constraints
    func setUpConstraints() {

        postArtLabel.snp.makeConstraints{ make in
            make.top.equalTo(75)
            make.left.equalTo(self.view).offset(75)
        }
        
        artTitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(postArtLabel).offset(75)
            make.left.equalTo(postArtLabel).offset(75)
        }
        
        artPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(artTitleLabel).offset(100)
            make.left.equalTo(artTitleLabel)
        }
        
        artImageView.snp.makeConstraints{ make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        uploadButton.snp.makeConstraints{ make in
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.center.equalTo(self.view)
        }
        
        postButton.snp.makeConstraints { make in
            make.top.equalTo(artImageView).offset(300)
            make.left.equalTo(artTitleLabel).offset(75)
            make.width.equalTo(100)
        }
        
    }
}
 
//MARK: - Extensions
extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        self.image = image
        
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {return}
        //MARK: To Do - Refactor when Image is being saved
        FirebaseStorageService.manager.storeImage(image: imageData) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let url):
                self?.imageURL = url
                
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}

