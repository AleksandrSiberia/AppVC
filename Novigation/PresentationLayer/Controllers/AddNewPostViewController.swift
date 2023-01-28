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



    private lazy var gestureRecognizer: UITapGestureRecognizer = {
        var gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector( gestureRecognizerAction(recogniser:)))
        gestureRecognizer.delegate = self
        return gestureRecognizer

    }()

    private lazy var imageViewPost: UIImageView = {
        var imageViewPost = UIImageView(image: UIImage(systemName: "plus"))
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



    private lazy var textField: UITextField = {
        var textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        return textField
    }()


    private lazy var buttonAddPost: CustomButton = {
        var buttonAddPost = CustomButton(title: "Добавить пост") {


            if let imagePost = self.imagePost, let text = self.textField.text, text != ""  {

                self.fileManagerService?.saveImage(imageData: imagePost, completionHandler: { tuple in

                    guard let tuple else {
                        print("‼️ error: fileManagerService?.saveImage" )
                        return }

                    let imageURL = tuple.2

                    self.coreDataCoordinator?.appendPost(author: "NewPost", image: nil, likes: "0", text: text, views: "0", folderName: "AllPosts", nameForUrlFoto: imageURL) {_ in}

                    self.coreDataCoordinator?.performFetchPostCoreData()

                    self.alert(alertMassage: "Пост сохранен")

                })

            }

            else {

                self.alert(alertMassage: "Добавьте фото c текстом")

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

        [imageViewPost, textField, buttonAddPost].forEach { self.view.addSubview($0) }

        self.imagePicker.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)

        self.view.backgroundColor = .white
        self.navigationItem.title = "Добавить новый пост"

        self.setupConstrains()

    }



    func alert(alertMassage: String?) {

        let alert = UIAlertController(title: nil, message: alertMassage, preferredStyle: .actionSheet)

        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(action)

        self.present(alert, animated: true)
    }



    func setupConstrains() {

        let viewSafeAreaLayoutGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            self.imageViewPost.topAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.topAnchor, constant: 15),
            self.imageViewPost.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageViewPost.widthAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.widthAnchor),
            self.imageViewPost.heightAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.widthAnchor),

            self.textField.topAnchor.constraint(equalTo: self.imageViewPost.bottomAnchor, constant: 15),
            self.textField.leadingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.leadingAnchor),
            self.textField.trailingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.trailingAnchor),


            self.buttonAddPost.topAnchor.constraint(equalTo: self.textField.bottomAnchor, constant: 15),
            self.buttonAddPost.bottomAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.bottomAnchor, constant: -15),
            self.buttonAddPost.leadingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.leadingAnchor, constant: 15),
            self.buttonAddPost.trailingAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.trailingAnchor, constant: -15)
        ])
    }



    @objc func gestureRecognizerAction(recogniser: UITapGestureRecognizer) {


        if recogniser.state == .ended {

            let tapLocation = recogniser.location(in: self.view)

            let frameImage = imageViewPost.frame

            if frameImage.minX <= tapLocation.x, frameImage.maxX >= tapLocation.x, frameImage.minY <= tapLocation.y, frameImage.maxY >= tapLocation.y  {

                present(imagePicker, animated: true)
            }
        }
    }



}




extension AddNewPostViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        self.imageViewPost.image = image
        self.imagePost = image

    }
}


extension AddNewPostViewController: UIGestureRecognizerDelegate {

}
