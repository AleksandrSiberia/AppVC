//
//  PostCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 15.06.2022.
//

import UIKit
import iOSIntPackage

class PostCell: UITableViewCell {


    private var currentPost: PostCoreData? 

    private var nameImage: String?

    private var nameForUrlFoto: String?

    var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var delegate: ProfileViewControllerDelegate?

    private lazy var viewEditPost: ViewEditPost = {

        var viewEditPost = ViewEditPost()
        viewEditPost.isHidden = true
        viewEditPost.translatesAutoresizingMaskIntoConstraints = false
        viewEditPost.clipsToBounds = true

        return viewEditPost
    }()


    private lazy var authorLabel: UILabel = {
        var authorLabel = UILabel()

        authorLabel.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.numberOfLines = 0
        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        authorLabel.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return authorLabel
    }()


    private lazy var buttonEditPost: UIButton = {

        let action = UIAction() { _ in

            let imageConfigurations = UIImage.SymbolConfiguration(scale: .large)
            self.buttonEditPost.setImage(UIImage(systemName: "ellipsis.rectangle.fill", withConfiguration: imageConfigurations), for: .normal)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let imageConfigurations = UIImage.SymbolConfiguration(scale: .large)
                self.buttonEditPost.setImage(UIImage(systemName: "ellipsis", withConfiguration: imageConfigurations), for: .normal)
            }

            if self.viewEditPost.isHidden == true {
                self.viewEditPost.isHidden = false
            }
            else {
                self.viewEditPost.isHidden = true
            }
        }

        let buttonEditPost = UIButton(frame: CGRect(), primaryAction: action)

        let imageConfigurations = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfigurations)
        buttonEditPost.setImage(image, for: .normal)
        buttonEditPost.tintColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)

        buttonEditPost.contentMode = .scaleAspectFit
        buttonEditPost.translatesAutoresizingMaskIntoConstraints = false
        return buttonEditPost
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

        setupViews()
        setupConstrains()

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    func setupViews() {

        [authorLabel, buttonEditPost, postImageView, descriptionLabel, likesLabel, viewsLabel, viewEditPost].forEach {
            contentView.addSubview($0)
        }
    }


    private func setupConstrains() {


        NSLayoutConstraint.activate( [

            viewEditPost.topAnchor.constraint(equalTo: buttonEditPost.bottomAnchor),
            viewEditPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            viewEditPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            viewEditPost.heightAnchor.constraint(equalToConstant: 300),

            authorLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            authorLabel.bottomAnchor.constraint(equalTo: postImageView.topAnchor, constant: -12),

            buttonEditPost.centerYAnchor.constraint(equalTo: authorLabel.centerYAnchor),
            buttonEditPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            postImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            postImageView.bottomAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: -16),

            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: likesLabel.topAnchor, constant: -16),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),

            likesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            likesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),

            viewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            viewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
        ])
    }


    func viewEditPostIsHidden() {
        viewEditPost.isHidden = true
    }


    func savePost() -> String? {

        if currentPost?.favourite != "save" {
            
            currentPost?.favourite = "save"
            coreDataCoordinator?.savePersistentContainerContext()
            return nil
        }
        else {
            return "этот пост уже сохранён" .allLocalizable
        }
    }


    
    func setupCell(post: PostCoreData?, coreDataCoordinator: CoreDataCoordinatorProtocol?, profileVC: ProfileViewControllerDelegate?, savedPostsVC: SavedPostsViewControllerDelegate?) {

        guard let post else {
            print("‼️ PostCoreData? == nil")
            return
        }


        self.viewEditPost.delegate = profileVC
        self.viewEditPost.delegateAlternative = savedPostsVC

        self.currentPost = post
        self.delegate = profileVC

        self.viewEditPost.currentPost = post
        self.viewEditPost.coreDataCoordinator = coreDataCoordinator

        let urlDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first


        self.coreDataCoordinator = coreDataCoordinator

        authorLabel.text = (post.author ?? "") + " " + (post.surname ?? "")

        nameImage = post.image

        nameForUrlFoto = post.urlFoto

        let filter = ImageProcessor()

        var filteredImage: UIImage?


        if let nameForUrlFoto, nameForUrlFoto != "" {

            guard let urlDocument else { return }

            let fileURL = "file://" + urlDocument + "/" + nameForUrlFoto



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


                filter.processImage(sourceImage: image, filter: ColorFilter.noir) { outputImage in
                    filteredImage = outputImage
                }
            }
            catch {
                print(error.localizedDescription)
            }
        }


        else {

            guard let image = UIImage(named: post.image ?? "") else {
                print("‼️ image = UIImage(named: image ?? ) == nil")
                return
            }

            filter.processImage(sourceImage: image, filter: ColorFilter.noir) { outputImage in
                filteredImage = outputImage
            }
        }

        
        let localized = NSLocalizedString("LocalizedLike", tableName: "LocalizableDict", comment: "")
        let likeValue = Int(post.likes ?? "") ?? 0
        let formatLocalized = String(format: localized, likeValue)

        postImageView.image = filteredImage
        descriptionLabel.text = post.text
        
        likesLabel.text = formatLocalized

        let localizedViews = NSLocalizedString("LocalizedView", tableName: "LocalizableDict", comment: "")
        let viewsValue = Int(post.views ?? "") ?? 0
        let formatLocalizedViews = String(format: localizedViews, viewsValue)

        viewsLabel.text = formatLocalizedViews
            }
}

