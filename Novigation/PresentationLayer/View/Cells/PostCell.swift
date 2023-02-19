//
//  PostCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 15.06.2022.
//

import UIKit
import iOSIntPackage

class PostCell: UITableViewCell {


    var currentPost: PostCoreData?

    

    private var nameImage: String?

    private var nameForUrlFoto: String?

    var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var delegate: ProfileViewControllerDelegate?

    private var delegateAlternative: SavedPostsViewControllerDelegate?

    var countViews: Bool?

    private var myConstraints: [NSLayoutConstraint] = []



    private var imageViewAuthorAvatar: UIImageView = {

        var imageViewAuthorAvatar = UIImageView()
        imageViewAuthorAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAuthorAvatar.layer.cornerRadius = 20
        imageViewAuthorAvatar.clipsToBounds = true

        return imageViewAuthorAvatar
    }()


    private lazy var buttonComments: UIButton = {

        let action = UIAction() { _ in

            if self.tableViewComment.isHidden {

                self.tableViewComment.isHidden = false


                self.setupConstrains(newTableViewCommentHeightAnchor: 200) {}

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.delegate?.reloadTableView()
                    self.delegateAlternative?.reloadTableView()
                }
            }

            else {

                self.tableViewComment.isHidden = true

                self.setupConstrains(newTableViewCommentHeightAnchor: 0) {}
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                   self.delegate?.reloadTableView()
                   self.delegateAlternative?.reloadTableView()
                }

            }
        }

        var buttonComments = UIButton(frame: CGRect(), primaryAction: action)

        buttonComments.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(systemName: "message", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

        buttonComments.setImage(image, for: .normal)

        buttonComments.tintColor = UIColor.createColorForTheme(lightTheme: .gray, darkTheme: .white)

        return buttonComments
    }()



    private lazy var tableViewComment: UITableView = {

        var tableViewComment = UITableView()

        tableViewComment.isHidden = true

        tableViewComment.translatesAutoresizingMaskIntoConstraints = false
        tableViewComment.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.name)

        tableViewComment.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        tableViewComment.dataSource = self
        tableViewComment.delegate = self

        return tableViewComment
    }()


    private lazy var viewEditPost: ViewEditPost = {
        var viewEditPost = ViewEditPost()
        viewEditPost.isHidden = true
        viewEditPost.translatesAutoresizingMaskIntoConstraints = false
        viewEditPost.clipsToBounds = true
        return viewEditPost
    }()


    private lazy var labelAuthor: UILabel = {
        var         labelAuthor = UILabel()
        labelAuthor.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        labelAuthor.translatesAutoresizingMaskIntoConstraints = false
        labelAuthor.numberOfLines = 0
        labelAuthor.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        labelAuthor.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return         labelAuthor
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



    private lazy var imageViewPost: UIImageView = {
        var imageViewPost = UIImageView()

        imageViewPost.translatesAutoresizingMaskIntoConstraints = false
        imageViewPost.backgroundColor = .black
        imageViewPost.contentMode = .scaleAspectFit
        imageViewPost.clipsToBounds = true
        return imageViewPost
    }()




    private lazy var labelText: UILabel = {
        var labelText = UILabel()
        labelText.translatesAutoresizingMaskIntoConstraints = false
        labelText.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        labelText.numberOfLines = 0
        labelText.font = UIFont.systemFont(ofSize: 14)
        labelText.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return labelText
    }()


    private lazy var labelLikes: UILabel = {
        var labelLikes = UILabel()
        labelLikes.translatesAutoresizingMaskIntoConstraints = false
        labelLikes.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        labelLikes.numberOfLines = 0
        labelLikes.font = UIFont.systemFont(ofSize: 16)
        labelLikes.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return labelLikes
    }()


    private lazy var buttonLike: UIButton = {

        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

        let action = UIAction() { _ in

            if self.currentPost?.likeYou == true {

                self.currentPost?.likeYou = false

                if (self.currentPost?.likes ?? 0) > 0 {
                    self.currentPost?.likes -= 1
                }

                self.coreDataCoordinator?.savePersistentContainerContext()

                self.delegate?.reloadTableView()
                self.delegateAlternative?.reloadTableView()


                let image = UIImage(systemName: "heart", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

                self.buttonLike.tintColor = .gray
                self.buttonLike.setImage(image, for: .normal)
            }


            else {

                self.currentPost?.likeYou = true
                self.currentPost?.likes += 1
                self.coreDataCoordinator?.savePersistentContainerContext()

                self.delegate?.reloadTableView()
                self.delegateAlternative?.reloadTableView()

                let image = UIImage(systemName: "heart.fill", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

                self.buttonLike.tintColor = UIColor(named: "orange")
                self.buttonLike.setImage(image, for: .normal)
            }
        }

        var buttonLike = UIButton(frame: CGRect(), primaryAction: action)

        buttonLike.translatesAutoresizingMaskIntoConstraints = false

        return buttonLike
    }()



    private lazy var labelViews: UILabel = {
        var labelViews = UILabel()
        labelViews.translatesAutoresizingMaskIntoConstraints = false
        labelViews.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .systemGray6)
        labelViews.numberOfLines = 0
        labelViews.font = UIFont.systemFont(ofSize: 16)
        labelViews.textColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)
        return labelViews
    }()



    private lazy var buttonFavorite: UIButton = {

        let action = UIAction() { _ in

            if self.currentPost?.favourite == "save" {

                self.currentPost?.favourite = nil

                self.coreDataCoordinator?.savePersistentContainerContext()

                let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

                let image = UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

                self.buttonFavorite.setImage(image, for: .normal)

                self.buttonFavorite.tintColor = .gray
            }


            else {

                self.currentPost?.favourite = "save"

                self.coreDataCoordinator?.savePersistentContainerContext()

                let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

                let image = UIImage(systemName: "bookmark.slash", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

                self.buttonFavorite.tintColor = UIColor(named: "orange")

                self.buttonFavorite.setImage(image, for: .normal)
            }
        }

        var buttonFavorite = UIButton(primaryAction: action)

        buttonFavorite.translatesAutoresizingMaskIntoConstraints = false

        return buttonFavorite
    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()

        setupConstrains(newTableViewCommentHeightAnchor: 0) {}


    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }






    func setupViews() {

        [imageViewAuthorAvatar, labelAuthor, buttonEditPost, imageViewPost, labelText, buttonLike, labelLikes, labelViews, viewEditPost, buttonFavorite,  tableViewComment, buttonComments].forEach {
            contentView.addSubview($0)
        }
    }



    private func setupConstrains(newTableViewCommentHeightAnchor: CGFloat, completionHandler: @escaping () -> Void ) {



        NSLayoutConstraint.deactivate(self.myConstraints)

        delegate?.reloadTableView()
        delegateAlternative?.reloadTableView()

        self.myConstraints = [

            viewEditPost.topAnchor.constraint(equalTo: buttonEditPost.bottomAnchor),
            viewEditPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            viewEditPost.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 70),
            viewEditPost.heightAnchor.constraint(equalToConstant: 300),



            imageViewAuthorAvatar.centerYAnchor.constraint(equalTo: labelAuthor.centerYAnchor),
            imageViewAuthorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewAuthorAvatar.widthAnchor.constraint(equalToConstant: 40),
            imageViewAuthorAvatar.heightAnchor.constraint(equalToConstant: 40),

            labelAuthor.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            labelAuthor.leadingAnchor.constraint(equalTo: imageViewAuthorAvatar.trailingAnchor, constant: 20),
            labelAuthor.trailingAnchor.constraint(equalTo: buttonEditPost.leadingAnchor, constant: -5),


            buttonEditPost.centerYAnchor.constraint(equalTo: labelAuthor.centerYAnchor),
            buttonEditPost.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -22),

            imageViewPost.topAnchor.constraint(equalTo: labelAuthor.bottomAnchor, constant: 18),
            imageViewPost.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            imageViewPost.heightAnchor.constraint(equalTo: contentView.widthAnchor),
            imageViewPost.bottomAnchor.constraint(equalTo: labelText.topAnchor, constant: -16),

            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),


            buttonLike.topAnchor.constraint(equalTo: labelText.bottomAnchor, constant: 20),
            buttonLike.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),


            labelLikes.leadingAnchor.constraint(equalTo: buttonLike.trailingAnchor, constant: 10),
            labelLikes.centerYAnchor.constraint(equalTo: buttonLike.centerYAnchor),


            labelViews.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            labelViews.centerYAnchor.constraint(equalTo: labelLikes.centerYAnchor),


            buttonComments.centerYAnchor.constraint(equalTo: labelViews.centerYAnchor),
            buttonComments.trailingAnchor.constraint(equalTo: buttonFavorite.leadingAnchor, constant: -25),


            buttonFavorite.centerYAnchor.constraint(equalTo: labelViews.centerYAnchor),
            buttonFavorite.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -26),

            tableViewComment.topAnchor.constraint(equalTo: buttonFavorite.bottomAnchor, constant: 15),
            tableViewComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tableViewComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tableViewComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            tableViewComment.heightAnchor.constraint(equalToConstant: newTableViewCommentHeightAnchor)

        ]

        NSLayoutConstraint.activate( self.myConstraints )


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


    private func setupImageForButtonLike(post: PostCoreData) {

        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

        if post.likeYou == true {

            let image = UIImage(systemName: "heart.fill", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

            self.buttonLike.tintColor = UIColor(named: "orange")
            self.buttonLike.setImage(image, for: .normal)
        }

        else {

            let image = UIImage(systemName: "heart", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

            self.buttonLike.tintColor = .gray
            self.buttonLike.setImage(image, for: .normal)

        }
    }


    private func setupImageForButtonFavorite(post: PostCoreData) {

        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

        if post.favourite == "save" {
            let image = UIImage(systemName: "bookmark.slash", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
            buttonFavorite.setImage(image, for: .normal)
            buttonFavorite.tintColor = UIColor(named: "orange")
        }

        else {
            let image = UIImage(systemName: "bookmark", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
            buttonFavorite.setImage(image, for: .normal)
            buttonFavorite.tintColor = .gray
        }
    }



    private func setupImageForPost(post: PostCoreData) {

        let urlDocument = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

        self.nameImage = post.image
        self.nameForUrlFoto = post.urlFoto


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
        imageViewPost.image = filteredImage
    }



    private func setupLabelLikes(post: PostCoreData) {

        let localized = NSLocalizedString("LocalizedLike", tableName: "LocalizableDict", comment: "")
        let likeValue = post.likes
        let formatLocalized = String(format: localized, likeValue)

        labelLikes.text = formatLocalized
    }




    private func setupLabelViews(post: PostCoreData) {

        let localizedViews = NSLocalizedString("LocalizedView", tableName: "LocalizableDict", comment: "")

        let viewsValue = post.views

        let formatLocalizedViews = String(format: localizedViews, viewsValue)
        labelViews.text = formatLocalizedViews

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
        self.delegateAlternative = savedPostsVC
        self.viewEditPost.currentPost = post
        self.viewEditPost.coreDataCoordinator = coreDataCoordinator
        self.coreDataCoordinator = coreDataCoordinator

        setupImageForButtonFavorite(post: post)
        setupImageForButtonLike(post: post)
        setupImageForPost(post: post)
        setupLabelLikes(post: post)
        setupLabelViews(post: post)

        imageViewAuthorAvatar.image = UIImage(named: post.relationshipProfile?.avatar ?? "")
        labelAuthor.text = (post.author ?? "") + " " + (post.surname ?? "")
        labelText.text = post.text
    }
}



extension PostCell: UITableViewDataSource, UITableViewDelegate {

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//
//        3
//    }




    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {

            guard let comments = currentPost?.relationshipArrayComments?.allObjects as? [CommentCoreData] else {

                print("‼️ currentPost?.relationshipArrayComments?.allObjects == nil")

                return 0
            }

            return comments.count
        }

        else {

           return  1
        }
    }



    func  numberOfSections(in tableView: UITableView) -> Int {
        2
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {



        if indexPath.section == 0 {

            guard let cell = tableViewComment.dequeueReusableCell(withIdentifier: CommentTableViewCell.name, for: indexPath) as? CommentTableViewCell

            else {
                print("‼️ tableViewComment.dequeueReusableCell(withIdentifier: CommentTableViewCell.name == nil")
                return UITableViewCell()
            }

            guard let comments = currentPost?.relationshipArrayComments?.allObjects as? [CommentCoreData], comments.count - 1 >= indexPath.row

            else {
                print("‼️ currentPost?.relationshipArrayComments?.allObjects == nil")

                return cell
            }

            let commentsSortByTime = comments.sorted { $0.time! < $1.time! }


            cell.setupCellAllComments(currentPost: currentPost, coreData: coreDataCoordinator, currentComment: commentsSortByTime[indexPath.row] )

            return cell
        }



        else {

            guard let cell = tableViewComment.dequeueReusableCell(withIdentifier: CommentTableViewCell.name, for: indexPath) as? CommentTableViewCell

            else {
                print("‼️ tableViewComment.dequeueReusableCell(withIdentifier: CommentTableViewCell.name == nil")
                return UITableViewCell()
            }

            cell.setupCellNewComment(currentPost: currentPost, coreData: coreDataCoordinator)

            return cell
        }
    }


}
