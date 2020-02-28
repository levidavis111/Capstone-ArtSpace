
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
    //MARK: TO DO - Add Text alignment to UI Utilities
    lazy var createPostLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Tell us about your art! Fill out the fields below."
        label.font = UIFont(name: "Avenir-Next", size: 30)
        return label
    }()
    
    lazy var artTitleTextfield: UITextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: "Name Of Art",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return textfield
    }()
    
    lazy var artPriceLabel: UITextField = {
        let label = UITextField()
        label.layer.borderWidth = 1.0
        label.layer.borderColor = UIColor.black.cgColor
        label.textAlignment = .center
        label.attributedPlaceholder = NSAttributedString(string: "Price",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return label
    }()
    
    lazy var dimensionsLabel: UILabel = {
        let label = UILabel()
        label.text = "Dimensions: "
        return label
    }()
    
    lazy var widthTexfield: UITextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: "width",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return textfield
    }()
    
    lazy var heightTextfield: UITextField = {
        let textfield = UITextField()
        textfield.layer.borderWidth = 1.0
        textfield.layer.borderColor = UIColor.black.cgColor
        textfield.textAlignment = .center
        textfield.attributedPlaceholder = NSAttributedString(string: "height",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        return textfield
    }()
    
    lazy var descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.black.cgColor
        textView.text = "Artwork description goes here"
        textView.backgroundColor = .clear
        textView.font = UIFont(name: "AvenirNext-Medium", size: 18)
        textView.textColor = .lightGray
        //MARK: TODO: Make a function to dismiss keyboard
        //MARK: change .isEditable to true
        textView.isEditable = false
        return textView
    }()
    
    lazy var artImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "icloud.and.arrow.down.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderWidth = 1.0
        imageView.layer.borderColor = UIColor.black.cgColor
        return imageView
    }()
    
    lazy var uploadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(uploadButtonPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton()
        button.layer.borderWidth = 5.0
        button.layer.cornerRadius = 15
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIUtilities.setViewBackgroundColor(view)
        setupNavigationBar()
        addSubviews()
        setUpConstraints()
    }
    
    //MARK: - Obj-C Functions
    @objc func transitionOut() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func submitButtonPressed() {
        showAlert(with: "Art Posted", and: "Now available for Sale!")
        //    createArtObject()
    }
    
    @objc func uploadButtonPressed() {
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
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
        print("Submit Button Pressed. Data gets loaded intro Firebase")
    }
    
    private func setupNavigationBar() {
        let title = "Sell Your Art!"
        let attrs = [
            //MARK: TO DO - Get right font Avenir Next
            //MARK: To Do - Move navigation configurations to UI Utilities
            NSAttributedString.Key.foregroundColor: UIColor.systemBlue,
            NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 25)]
        navigationController?.navigationBar.titleTextAttributes = attrs as [NSAttributedString.Key : Any]
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationController?.navigationBar.topItem?.title = "\(title)"
    }
    
    //MARK: UISetup
    func addSubviews() {
        [createPostLabel, artTitleTextfield,  artPriceLabel, dimensionsLabel, widthTexfield, heightTextfield, descriptionTextView, artImageView, uploadButton, submitButton].forEach({self.view.addSubview($0)})
    }
    
    //MARK: TO DO - Fix constraints
    func setUpConstraints() {
        
        createPostLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
        }
        
        artTitleTextfield.snp.makeConstraints{ make in
            make.top.equalTo(createPostLabel).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            make.height.equalTo(25)
        }
        
        artPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(artTitleTextfield).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            make.height.equalTo(25)
            
        }
        
        dimensionsLabel.snp.makeConstraints { (make) in
            make.top.equalTo(artPriceLabel).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.height.equalTo(25)
        }
        
        widthTexfield.snp.makeConstraints { (make) in
            make.top.equalTo(artPriceLabel).offset(50)
            make.right.equalTo(dimensionsLabel).offset(75)
            make.width.equalTo(75)
            make.height.equalTo(25)
        }
        
        heightTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(artPriceLabel).offset(50)
            make.right.equalTo(widthTexfield).offset(100)
            make.width.equalTo(75)
            make.height.equalTo(25)
        }
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(widthTexfield).offset(50)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(25)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-25)
            make.height.equalTo(100)
        }
        
        artImageView.snp.makeConstraints{ make in
            make.top.equalTo(descriptionTextView).offset(125)
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        uploadButton.snp.makeConstraints{ make in
            make.top.equalTo(descriptionTextView).offset(150)
            make.width.equalTo(200)
            make.height.equalTo(200)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
        }
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalTo(artImageView).offset(40)
            make.centerX.equalTo(view.safeAreaLayoutGuide)
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
        FirebaseStorageService.manager.storeImage(pictureType: .artPiece, image: imageData) { [weak self] (result) in
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
