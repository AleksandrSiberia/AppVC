//
//  AddNewPostViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 28.01.2023.
//

import UIKit

class AddNewPostViewController: UIViewController {


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
 //       imageViewPost.addGestureRecognizer(gestureRecognizer)
        return imageViewPost
    }()


    private lazy var imagePicker: UIImagePickerController = {

        var imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        return imagePicker
    }()


    override func viewDidLoad() {
        super.viewDidLoad()

        [imageViewPost].forEach { self.view.addSubview($0) }

        self.imagePicker.delegate = self
        self.view.addGestureRecognizer(gestureRecognizer)

        self.view.backgroundColor = .white
        self.navigationItem.title = "Добавить новый пост"

        self.setupConstrains()

    }


    func setupConstrains() {

        let viewSafeAreaLayoutGuide = self.view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            self.imageViewPost.topAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.topAnchor, constant: 15),
            self.imageViewPost.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.imageViewPost.widthAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.widthAnchor),
            self.imageViewPost.heightAnchor.constraint(equalTo: viewSafeAreaLayoutGuide.widthAnchor),


        ])
    }



    @objc func gestureRecognizerAction(recogniser: UITapGestureRecognizer) {


        if recogniser.state == .ended {

            let tapLocation = recogniser.location(in: self.view)

            let frameImage = imageViewPost.frame

            if frameImage.minX <= tapLocation.x, frameImage.maxX >= tapLocation.x, frameImage.minY <= tapLocation.y, frameImage.maxY >= tapLocation.y  {

                print("🧽", tapLocation, frameImage )
            }
        }
    }



}




extension AddNewPostViewController: UIImagePickerControllerDelegate,  UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage

        self.imageViewPost.image = image
    }
}


extension AddNewPostViewController: UIGestureRecognizerDelegate {

}
