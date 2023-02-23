//
//  CommentAllTableViewCell.swift
//  Novigation
//
//  Created by Александр Хмыров on 20.02.2023.
//


import UIKit
import KeychainSwift


class CommentAllTableViewCell: UITableViewCell, CommentTableViewCellProtocol {

    private var currentPost: PostCoreData?
    private var coreData: CoreDataCoordinatorProtocol?
    private var currentProfile: ProfileCoreData?
    private var delegate: PostCell?

    private lazy var imageViewAuthorAvatar: UIImageView = setupViewAuthorAvatar()


    private var labelComment: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray6
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        label.layer.cornerRadius = 14
        label.clipsToBounds = true
        return label
    }()


    private var labelDate: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textColor = UIColor.createColorForTheme(lightTheme: .gray, darkTheme: .systemGray)
        return label
    }()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [imageViewAuthorAvatar, labelComment, labelDate].forEach { contentView.addSubview( $0) }
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

            imageViewAuthorAvatar.centerYAnchor.constraint(equalTo: labelComment.centerYAnchor),
            imageViewAuthorAvatar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            imageViewAuthorAvatar.heightAnchor.constraint(equalToConstant: 30),
            imageViewAuthorAvatar.widthAnchor.constraint(equalToConstant: 30),


            labelComment.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            labelComment.leadingAnchor.constraint(equalTo: imageViewAuthorAvatar.trailingAnchor, constant: 15),
            labelComment.heightAnchor.constraint(equalToConstant: 40),
            labelComment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),

            labelDate.leadingAnchor.constraint(equalTo: labelComment.trailingAnchor, constant: 10),
            labelDate.bottomAnchor.constraint(equalTo: labelComment.bottomAnchor),

        ])
    }



    func setupLabelDate(currentComment: CommentCoreData?) {

        let dateFormater = DateFormatter()

        dateFormater.dateFormat = "HH:mm"

        guard let date = currentComment?.time else  { return }

        let dateString = dateFormater.string(from: date)

        labelDate.text = dateString
    }



    func setupCellAllComments(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?, currentComment: CommentCoreData?) {

        self.currentPost = currentPost
        self.coreData = coreData

        setupLabelDate(currentComment: currentComment)

        setupImageViewAuthorAvatar(coreData: coreData, currentPost: currentPost) { image in
            self.imageViewAuthorAvatar.image = image
        }

        labelComment.text = currentComment?.text
    }
}



extension CommentAllTableViewCell {

    static var name: String {
        return String(describing: self)
    }
}

