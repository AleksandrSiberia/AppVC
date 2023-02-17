//
//  CommentTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 16.02.2023.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

  private var currentPost: PostCoreData?
  private var coreData: CoreDataCoordinatorProtocol?
  private var currentComments: CommentCoreData?


    private var imageViewAuthorAvatar = {

        var imageViewAuthorAvatar = UIImageView()
        imageViewAuthorAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAuthorAvatar.layer.cornerRadius = 15
        return imageViewAuthorAvatar
    }()


    private lazy var textFieldNewComment = UITextField.setupTextFieldComment(text: nil, keyboardType: .namePhonePad)



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)


        [imageViewAuthorAvatar, textFieldNewComment].forEach { contentView.addSubview( $0) }
        setupConstraints()

        backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .gray)
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

            imageViewAuthorAvatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            imageViewAuthorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewAuthorAvatar.heightAnchor.constraint(equalToConstant: 30),
            imageViewAuthorAvatar.widthAnchor.constraint(equalToConstant: 30),

            
            textFieldNewComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            textFieldNewComment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textFieldNewComment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textFieldNewComment.heightAnchor.constraint(equalToConstant: 40),
            textFieldNewComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

    

    func setupCellAllComments(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?, currentComment: CommentCoreData?) {

        self.currentPost = currentPost
        self.coreData = coreData
        self.currentComments = currentComment

        textFieldNewComment.isHidden = true
    }



    func setupCellNewComment(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?) {

        self.currentPost = currentPost
        self.coreData = coreData

        imageViewAuthorAvatar.isHidden = true
    }

}



extension CommentTableViewCell {

    static var name: String {
        print("🫐", String(describing: self))
        return String(describing: self)
    }
}
