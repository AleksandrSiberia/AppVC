//
//  CommentTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 16.02.2023.
//

import UIKit
import KeychainSwift


class CommentNewTableViewCell: UITableViewCell, CommentTableViewCellProtocol {

    private var currentPost: PostCoreData?
    private var coreData: CoreDataCoordinatorProtocol?
    private var currentProfile: ProfileCoreData?
    private var delegate: PostCell?



    private lazy var imageViewAuthorAvatar: UIImageView = setupViewAuthorAvatar()


    private lazy var textFieldNewComment = UITextField.setupTextFieldComment(text: nil, keyboardType: .namePhonePad)


    
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

                self.delegate?.reloadTableViewComment()
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


        [imageViewAuthorAvatar, textFieldNewComment, buttonSentComment].forEach { contentView.addSubview( $0) }
        setupConstraints()

    }
    

 


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }


    private func setupConstraints() {



        NSLayoutConstraint.activate([

            imageViewAuthorAvatar.centerYAnchor.constraint(equalTo: textFieldNewComment.centerYAnchor),
            imageViewAuthorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewAuthorAvatar.heightAnchor.constraint(equalToConstant: 30),
            imageViewAuthorAvatar.widthAnchor.constraint(equalToConstant: 30),


            textFieldNewComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            textFieldNewComment.leadingAnchor.constraint(equalTo: imageViewAuthorAvatar.trailingAnchor, constant: 15),
            textFieldNewComment.trailingAnchor.constraint(equalTo: buttonSentComment.leadingAnchor, constant: -10),
            textFieldNewComment.heightAnchor.constraint(equalToConstant: 40),
            textFieldNewComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            buttonSentComment.centerYAnchor.constraint(equalTo: textFieldNewComment.centerYAnchor),
            buttonSentComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
        ])
    }


   



    func setupCellNewComment(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?, delegate: PostCell?) {

        self.currentPost = currentPost
        self.coreData = coreData
        self.delegate = delegate

        setupImageViewAuthorAvatar(coreData: coreData, currentPost: currentPost) { image in
            self.imageViewAuthorAvatar.image = image
        }
    }
}



extension CommentNewTableViewCell {

    static var name: String {
        return String(describing: self)
    }
}
