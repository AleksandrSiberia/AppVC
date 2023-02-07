//
//  AddNewPostViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 28.01.2023.
//

import UIKit


class AddNewPostViewController: UIViewController {

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var fileManagerService: FileManagerServiceable?

    private var imagePost: UIImage?

    private var keyboardHided: Bool = true



    private lazy var labelAddImage: UILabel = {

        var labelAddImage = UILabel()
        labelAddImage.translatesAutoresizingMaskIntoConstraints = false

        if imageViewPost.image == nil {
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

    private lazy var scrollView: UIScrollView = {

        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()


    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( gestureRecognizerAction(recogniser:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer

    }()


    private lazy var imageViewPost: UIImageView = {
        var imageViewPost = UIImageView()

        imageViewPost.translatesAutoresizingMaskIntoConstraints = false
        imageViewPost.backgroundColor = .systemGray6
        imageViewPost.sizeToFit()
        return imageViewPost
    }()


    private lazy var imagePicker: UIImagePickerController = {
        var imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return imagePicker
    }()



    private lazy var textViewAddNewPost: UITextView = CustomViews.setupTextView(text: "textViewAddNewPost".allLocalizable)
    

    private lazy var buttonAddPost: CustomButton = {
        var buttonAddPost = CustomButton(title: "buttonAddPost".allLocalizable) {


            if let imagePost = self.imagePost, let text = self.textViewAddNewPost.text, text != ""  {

                self.fileManagerService?.saveImage(imageData: imagePost, completionHandler: { tuple in

                    guard let tuple else {
                        print("‼️ error: fileManagerService?.saveImage" )
                        return }

                    let imageURL = tuple.2

                    self.coreDataCoordinator?.appendPost(author: "NewPost", image: nil, likes: "0", text: text, views: "0", folderName: "AllPosts", nameForUrlFoto: imageURL) {_ in}

                    self.coreDataCoordinator?.performFetchPostCoreData()

                    self.alert(alertMassage: "buttonAddPostAlertSuccess".allLocalizable, handler: { self.dismiss(animated: true) })

                })
            }


            else {

                self.alert(alertMassage: "buttonAddPostAlertFailed".allLocalizable, handler: nil)

            }
        }
        return buttonAddPost
    }()



    init(coreDataCoordinator: CoreDataCoordinatorProtocol?, fileManagerService: FileManagerServiceable?) {
        super.init(nibName: nil, bundle: nil)

        self.coreDataCoordinator = coreDataCoordinator
        self.fileManagerService = fileManagerService
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()


        view.addSubview(scrollView)
        [imageViewPost, textViewAddNewPost, buttonAddPost, labelAddImage].forEach { scrollView.addSubview($0) }


        navigationItem.leftBarButtonItem = barButtonItemCancel

        self.imagePicker.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)

        self.view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white , darkTheme: .black )
        self.navigationItem.title = "AddNewPostViewControllerTitle".allLocalizable

        textViewAddNewPost.delegate = self
        textViewAddNewPost.textColor = .systemGray

        self.setupConstrains()

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)


        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }



    private func setupConstrains() {

        let viewSafeAreaLayoutGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            self.scrollView.topAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.scrollView.trailingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.trailingAnchor, constant: -15),
            self.scrollView.bottomAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.bottomAnchor, constant: -15),

            self.imageViewPost.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 15),
            self.imageViewPost.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageViewPost.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            self.imageViewPost.heightAnchor.constraint(equalTo: scrollView.widthAnchor),

            self.textViewAddNewPost.topAnchor.constraint(equalTo: self.imageViewPost.bottomAnchor, constant: 15),
            self.textViewAddNewPost.heightAnchor.constraint(equalToConstant: view.frame.width / 2 ),
            self.textViewAddNewPost.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            self.buttonAddPost.topAnchor.constraint(equalTo: self.textViewAddNewPost.bottomAnchor, constant: 15),
            self.buttonAddPost.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            self.buttonAddPost.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

            labelAddImage.centerXAnchor.constraint(equalTo: imageViewPost.centerXAnchor),
            labelAddImage.centerYAnchor.constraint(equalTo: imageViewPost.centerYAnchor),
        ])
    }


    @objc private func barButtonItemCancelAction() {
        dismiss(animated: true)
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



    @objc private func keyboardDidShow(notification: Notification) {

        keyboardHided = false

        guard let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey ] as? NSValue)?.cgRectValue.height else { return }

        let heightView = view.frame.height

        let screen = view.window?.screen.bounds.height

        guard let screen else { return }

        let navigationBarHeight = screen - heightView

        let bottomScrollViewElements = buttonAddPost.frame.maxY

        let keyboardTop = heightView - keyboardHeight

        if bottomScrollViewElements > keyboardTop {

            let contentOffSet = bottomScrollViewElements - keyboardTop + navigationBarHeight + 15

            scrollView.contentOffset.y = contentOffSet
        }
    }



    @objc private func keyboardWillHide(notification: Notification) {

        keyboardHided = true

        scrollView.contentOffset.y = 0.0
    }



    @objc func gestureRecognizerAction(recogniser: UITapGestureRecognizer) {

        if recogniser.state == .ended {

            let tapLocation = recogniser.location(in: self.view)

            let frameImage = imageViewPost.frame

            if keyboardHided == false {
                view.endEditing(true)
            }

            else {

                if frameImage.minX <= tapLocation.x, frameImage.maxX >= tapLocation.x, frameImage.minY <= tapLocation.y, frameImage.maxY >= tapLocation.y  {


                    present(imagePicker, animated: true)
                }
            }
        }
    }
}




extension AddNewPostViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        self.imageViewPost.image = image
        self.imagePost = image

        self.labelAddImage.isHidden = true

    }
}


extension AddNewPostViewController: UIGestureRecognizerDelegate {

}



extension AddNewPostViewController: UITextViewDelegate {

    func textViewDidBeginEditing(_ textView: UITextView) {

        if textViewAddNewPost.textColor == .systemGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
}

