//
//  AddNewPostViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 28.01.2023.
//

import UIKit
import KeychainSwift


class AddNewPostViewController: UIViewController, KeyboardServiceProtocol {

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var fileManagerService: FileManagerServiceable?

    private var imagePost: UIImage?

    private var keyboardHeight: CGFloat?

    var currentProfile: ProfileCoreData?

    var delegate: ViewControllersDelegate?


    private lazy var gestureRecognizerEndEditingInScrollView = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerEndEditingInScrollViewAction))

    private lazy var labelAddImage: UILabel = {

        var labelAddImage = UILabel()
        labelAddImage.translatesAutoresizingMaskIntoConstraints = false

        if imageViewImageForNewPost.image == nil {
            labelAddImage.isHidden = false
        }
        else {
            labelAddImage.isHidden = true
        }

        labelAddImage.text = "labelAddImage".allLocalizable
        return labelAddImage
    }()



    private lazy var barButtonItemCancel: UIBarButtonItem = {
        var barButtonItemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(barButtonItemCancelAction))
        return barButtonItemCancel
    }()



    private lazy var scrollViewAddNewPostController: UIScrollView = {

        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()



    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( gestureRecognizerAction(recogniser:)))

        return gestureRecognizer
    }()


    private lazy var imageViewImageForNewPost: UIImageView = {
        var imageViewPost = UIImageView()

        imageViewPost.translatesAutoresizingMaskIntoConstraints = false
        imageViewPost.backgroundColor = .systemGray6
        imageViewPost.contentMode = .scaleAspectFit


        return imageViewPost
    }()


    private lazy var imagePicker: UIImagePickerController = {
        var imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return imagePicker
    }()



    private lazy var textViewAddNewPost = UITextView.setupTextView(text: "textViewAddNewPost".allLocalizable)
    

    
    private lazy var buttonAddPost: CustomButton = {

        var buttonAddPost = CustomButton(title: "buttonAddPost".allLocalizable) {

            if let imagePost = self.imagePost, let text = self.textViewAddNewPost.text, text != ""  {

                self.fileManagerService?.saveImage(imageData: imagePost, completionHandler: { tuple in

                    guard let tuple else {
                        print("‼️ error: fileManagerService?.saveImage" )
                        return }

                    let imageURL = tuple.2

                    let values: [String: Any]  =  ["author": self.currentProfile?.name ?? "",
                                                   "surname": self.currentProfile?.surname ?? "",
                                                   "image": "",
                                                   "text": text,
                                                   "likes": 0,
                                                   "views": 0,
                                                   "nameForUrlFoto": imageURL ]

                    guard let nameUserFolder = KeychainSwift().get("userOnline")

                    else  {
                        print("‼️ KeychainSwift().get(userOnline) == nil")
                        return
                    }

                    self.coreDataCoordinator?.appendPost(values: values, currentProfile: self.currentProfile, folderName: nameUserFolder)
                    {_ in}

                    self.delegate?.reloadTableView()

                    self.alert(alertMassage: "buttonAddPostAlertSuccess".allLocalizable, handler: {

                        self.navigationController?.popViewController(animated: true)
                    })
                })
            }

            else {

                self.alert(alertMassage: "buttonAddPostAlertFailed".allLocalizable, handler: nil)
            }
        }
        return buttonAddPost
    }()



    init(coreDataCoordinator: CoreDataCoordinatorProtocol?, fileManagerService: FileManagerServiceable?, delegate: ViewControllersDelegate?) {
        super.init(nibName: nil, bundle: nil)

        self.coreDataCoordinator = coreDataCoordinator
        self.fileManagerService = fileManagerService
        self.delegate = delegate


    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNotifications()

        view.addSubview(scrollViewAddNewPostController)

        [imageViewImageForNewPost, textViewAddNewPost, buttonAddPost, labelAddImage].forEach { scrollViewAddNewPostController.addSubview($0) }

        navigationItem.leftBarButtonItem = barButtonItemCancel

        imagePicker.delegate = self

        imageViewImageForNewPost.addGestureRecognizer(gestureRecognizer)
        imageViewImageForNewPost.isUserInteractionEnabled = true

        scrollViewAddNewPostController.addGestureRecognizer(gestureRecognizerEndEditingInScrollView)

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white , darkTheme: .black )
        navigationItem.title = "AddNewPostViewControllerTitle".allLocalizable

        textViewAddNewPost.delegate = self
        textViewAddNewPost.textColor = .systemGray

        setupConstrains()


    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }



    private func setupConstrains() {

        let viewSafeAreaLayoutGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            scrollViewAddNewPostController.topAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.topAnchor),
            scrollViewAddNewPostController.leadingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.leadingAnchor, constant: 15),
            scrollViewAddNewPostController.trailingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.trailingAnchor, constant: -15),
            scrollViewAddNewPostController.bottomAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.bottomAnchor, constant: -15),

            imageViewImageForNewPost.topAnchor.constraint(equalTo: scrollViewAddNewPostController.topAnchor),
            imageViewImageForNewPost.widthAnchor.constraint(equalTo: scrollViewAddNewPostController.widthAnchor),
            imageViewImageForNewPost.heightAnchor.constraint(equalTo: scrollViewAddNewPostController.widthAnchor),

            textViewAddNewPost.topAnchor.constraint(equalTo: imageViewImageForNewPost.bottomAnchor, constant: 20),
            textViewAddNewPost.heightAnchor.constraint(equalToConstant: 150),
            textViewAddNewPost.widthAnchor.constraint(equalTo: scrollViewAddNewPostController.widthAnchor),

            buttonAddPost.topAnchor.constraint(equalTo: textViewAddNewPost.bottomAnchor, constant: 15),
            buttonAddPost.widthAnchor.constraint(equalTo: scrollViewAddNewPostController.widthAnchor),
            buttonAddPost.bottomAnchor.constraint(equalTo: scrollViewAddNewPostController.bottomAnchor),

            labelAddImage.centerXAnchor.constraint(equalTo: imageViewImageForNewPost.centerXAnchor),
            labelAddImage.centerYAnchor.constraint(equalTo: imageViewImageForNewPost.centerYAnchor),
        ])
    }



    @objc private func barButtonItemCancelAction() {
        navigationController?.popViewController(animated: true)
    }



    private func setupNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }



    private func alert(alertMassage: String?, handler: (() -> Void)? ) {

        let alert = UIAlertController(title: nil, message: alertMassage, preferredStyle: .actionSheet)

        let action = UIAlertAction(title: "Ok", style: .cancel) { _ in

            if let handler {
                handler()
            }
        }

        alert.addAction(action)

        self.present(alert, animated: true)
    }



    @objc private func keyboardWillShow(notification: Notification) {

        keyboardWillShow(notifications: notification, view: view, viewScroll: scrollViewAddNewPostController, bottomElement: buttonAddPost, correction: 90)
    }



    @objc private func keyboardWillHide(notification: Notification) {

        scrollViewAddNewPostController.contentOffset.y = 0.0
    }



    @objc func gestureRecognizerEndEditingInScrollViewAction() {
        view.endEditing(true)
    }



    @objc func gestureRecognizerAction(recogniser: UITapGestureRecognizer) {

        if recogniser.state == .ended {

            let tapLocation = recogniser.location(in: view)

            let frameImage = imageViewImageForNewPost.frame

            if frameImage.minX <= tapLocation.x, frameImage.maxX >= tapLocation.x, frameImage.minY <= tapLocation.y, frameImage.maxY >= tapLocation.y  {

                present(imagePicker, animated: true)
            }
        }
    }
}




extension AddNewPostViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        self.imageViewImageForNewPost.image = image
        self.imagePost = image

        self.labelAddImage.isHidden = true
    }
}



extension AddNewPostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textViewAddNewPost.textColor == .systemGray {
            textView.text = nil
            textView.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        }
    }
}


