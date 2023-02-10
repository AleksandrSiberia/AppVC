//
//  PostCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 15.06.2022.
//

import UIKit
import iOSIntPackage

class PostCell: UITableViewCell {


    private var nameImage: String?

    private var urlFoto: String?

    var coreDataCoordinator: CoreDataCoordinatorProtocol!

    private lazy var authorLabel: UILabel = {
        var authorLabel = UILabel()

        authorLabel.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.numberOfLines = 2
        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        authorLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return authorLabel
    }()




    private lazy var postImageView: UIImageView = {
        var postImageView = UIImageView()
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postImageView.backgroundColor = .black
        postImageView.contentMode = .scaleAspectFit
        postImageView.clipsToBounds = true
        return postImageView
    }()




    private lazy var descriptionLabel: UILabel = {
        var descriptionLabel = UILabel()
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return descriptionLabel
    }()




    private lazy var likesLabel: UILabel = {
        var likesLabel = UILabel()
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        likesLabel.numberOfLines = 0
        likesLabel.font = UIFont.systemFont(ofSize: 16)
        likesLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return likesLabel
    }()




    private lazy var viewsLabel: UILabel = {
        var viewsLabel = UILabel()
        viewsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewsLabel.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        viewsLabel.numberOfLines = 0
        viewsLabel.font = UIFont.systemFont(ofSize: 16)
        viewsLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return viewsLabel
    }()




    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupView()

    }




    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }




    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
//            self.likesLabel.widthAnchor.constraint(equalToConstant: (self.frame.width / 2) - 16),
//            self.viewsLabel.widthAnchor.constraint(equalToConstant: (self.frame.width / 2) - 16)
        ])
    }




    func savePost() -> String? {

        var errorSave: String?

        let values: [String: String]  =  ["author": (authorLabel.text ?? ""),
                                          "image": (nameImage ?? ""),
                                          "text": (descriptionLabel.text ?? ""),
                                          "likes": (likesLabel.text ?? ""),
                                          "views": (viewsLabel.text ?? ""),
                                          "nameForUrlFoto": (urlFoto ?? "") ]

        
//        self.coreDataCoordinator.appendPost(author: self.authorLabel.text, image: self.nameImage, likes: self.likesLabel.text, text: self.descriptionLabel.text, views: self.viewsLabel.text, folderName: "SavedPosts", nameForUrlFoto: self.urlFoto)

        coreDataCoordinator.appendPost(values: values, folderName: "SavedPosts") { error in
            errorSave = error
        }
        return errorSave
    }



    private func setupView() {
        addSubview(authorLabel)
        addSubview(postImageView)
        addSubview(descriptionLabel)
        addSubview(likesLabel)
        addSubview(viewsLabel)

        NSLayoutConstraint.activate( [
            self.authorLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            self.authorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            self.authorLabel.bottomAnchor.constraint(equalTo: self.postImageView.topAnchor, constant: -12),


            self.postImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.postImageView.heightAnchor.constraint(equalTo: self.widthAnchor),
            self.postImageView.bottomAnchor.constraint(equalTo: self.descriptionLabel.topAnchor, constant: -16),


            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            self.descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            self.descriptionLabel.bottomAnchor.constraint(equalTo: self.likesLabel.topAnchor, constant: -16),
            self.descriptionLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),

            self.likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            self.likesLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),

            self.viewsLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            self.viewsLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
        ])
    }



    
    func setup(author: String?, image: String?, likes: String?, text: String?, views: String?, nameFoto: String?, coreDataCoordinator: CoreDataCoordinatorProtocol) {

        let urlDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

        self.coreDataCoordinator = coreDataCoordinator

        self.authorLabel.text = author

        self.nameImage = image

        self.urlFoto = nameFoto

        let filter = ImageProcessor()

        var filteredImage: UIImage?


        if let nameFoto, nameFoto != "" {

            guard let urlDocument else { return }

            let fileURL = "file://" + urlDocument + "/" + nameFoto

            print("🎄", fileURL, "🍒", nameFoto)



            do {

                guard let url = URL(string: fileURL) else {

                    print("‼️ URL(string: urlFoto) == nil")
                    return
                }
                let imageData = try Data(contentsOf: url )

                guard let image = UIImage(data: imageData) else {
                    print("‼️ UIImage(data: imageData == nil")
                    return
                }

                print("🏓", image, url)

                filter.processImage(sourceImage: image, filter: ColorFilter.noir) { outputImage in
                    filteredImage = outputImage
                }


            }
            catch {
                print(error.localizedDescription)
            }
        }


        else {

            guard let image = UIImage(named: image ?? "") else {
                print("‼️ image = UIImage(named: image ?? ) == nil")
                return
            }

            filter.processImage(sourceImage: image, filter: ColorFilter.noir) { outputImage in
                filteredImage = outputImage
            }
        }

        
        let localized = NSLocalizedString("LocalizedLike", tableName: "LocalizableDict", comment: "")
        let likeValue = Int(likes ?? "") ?? 0
        let formatLocalized = String(format: localized, likeValue)

        self.postImageView.image = filteredImage
        self.descriptionLabel.text = text
        
        self.likesLabel.text = formatLocalized

        let localizedViews = NSLocalizedString("LocalizedView", tableName: "LocalizableDict", comment: "")
        let viewsValue = Int(views ?? "") ?? 0
        let formatLocalizedViews = String(format: localizedViews, viewsValue)

        self.viewsLabel.text = formatLocalizedViews
            }
}

