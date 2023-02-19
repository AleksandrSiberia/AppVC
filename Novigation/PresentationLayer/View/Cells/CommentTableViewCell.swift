//
//  CommentTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 16.02.2023.
//

import UIKit
import KeychainSwift

class CommentTableViewCell: UITableViewCell {

  private var currentPost: PostCoreData?
  private var coreData: CoreDataCoordinatorProtocol?
  private var currentProfile: ProfileCoreData?


    private var imageViewAuthorAvatar: UIImageView = {

        var imageViewAuthorAvatar = UIImageView()
        imageViewAuthorAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAuthorAvatar.layer.cornerRadius = 15
        imageViewAuthorAvatar.clipsToBounds = true

        return imageViewAuthorAvatar
    }()


    private lazy var textFieldNewComment = UITextField.setupTextFieldComment(text: nil, keyboardType: .namePhonePad)


    private var labelComment: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()

    
    private lazy var buttonSentComment: UIButton = {

        let action = UIAction() { _ in
            
            
            let image = UIImage(systemName: "arrow.up.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)
            
            self.buttonSentComment.setImage(image, for: .normal)
            self.buttonSentComment.translatesAutoresizingMaskIntoConstraints = false


            self.coreData?.appendNewCommentInPost(for: self.currentPost, text: self.textFieldNewComment.text)

            self.textFieldNewComment.text = ""


            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                let image = UIImage(systemName: "arrow.up.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)
                
                self.buttonSentComment.setImage(image, for: .normal)
            }
        }

        var buttonSentComment = UIButton(frame: CGRect(), primaryAction: action)

        let image = UIImage(systemName: "arrow.up.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

        buttonSentComment.setImage(image, for: .normal)
        buttonSentComment.translatesAutoresizingMaskIntoConstraints = false

        buttonSentComment.tintColor = UIColor.createColorForTheme(lightTheme: .gray, darkTheme: .white)

        return buttonSentComment
    }()



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        [imageViewAuthorAvatar, textFieldNewComment, buttonSentComment, labelComment].forEach { contentView.addSubview( $0) }
        setupConstraints()

    }
    

 


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        print("🍌")
    }


    private func setupConstraints() {

        NSLayoutConstraint.activate([

            imageViewAuthorAvatar.centerYAnchor.constraint(equalTo: textFieldNewComment.centerYAnchor),
            imageViewAuthorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewAuthorAvatar.heightAnchor.constraint(equalToConstant: 30),
            imageViewAuthorAvatar.widthAnchor.constraint(equalToConstant: 30),


            textFieldNewComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            textFieldNewComment.leadingAnchor.constraint(equalTo: imageViewAuthorAvatar.trailingAnchor, constant: 15),
            textFieldNewComment.heightAnchor.constraint(equalToConstant: 40),
            textFieldNewComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            labelComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            labelComment.leadingAnchor.constraint(equalTo: imageViewAuthorAvatar.trailingAnchor, constant: 15),
            labelComment.heightAnchor.constraint(equalToConstant: 40),
            labelComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),

            buttonSentComment.leadingAnchor.constraint(equalTo: textFieldNewComment.trailingAnchor, constant: 10),
            buttonSentComment.centerYAnchor.constraint(equalTo: textFieldNewComment.centerYAnchor),
            buttonSentComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }

    

    func setupCellAllComments(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?, currentComment: CommentCoreData?) {

        self.currentPost = currentPost
        self.coreData = coreData

        textFieldNewComment.isHidden = true
        buttonSentComment.isHidden = true

        labelComment.text = currentComment?.text
    }

 


    func setupCellNewComment(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?) {

        self.currentPost = currentPost
        self.coreData = coreData

        labelComment.isHidden = true

        coreData?.getCurrentProfile(completionHandler: { profile in
            self.currentProfile = profile
        })


        guard let profile =  currentPost?.relationshipProfile

        else {
            print("‼️ currentPost?.relationFolder?.allObjects -> nil || isEmpty ")
            return
        }
        self.imageViewAuthorAvatar.image = UIImage(named: profile.avatar ?? "")
    }
}



extension CommentTableViewCell {

    static var name: String {
        return String(describing: self)
    }
}
