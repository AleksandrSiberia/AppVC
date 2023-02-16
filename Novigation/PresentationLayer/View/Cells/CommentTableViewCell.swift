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


    private lazy var textFieldCommit = UITextField.setupTextFieldComment(text: "Hi !!!!!!!!!!!!!!!!!!!!!!!!!!", keyboardType: .default)


    init() {
        super.init(style: .default, reuseIdentifier: nil)

        [textFieldCommit].forEach { addSubview( $0) }


   //     backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .gray)

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

            textFieldCommit.topAnchor.constraint(equalTo: contentView.topAnchor),
            textFieldCommit.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textFieldCommit.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textFieldCommit.widthAnchor.constraint(equalToConstant: 40),
            textFieldCommit.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    

    func setupCell(currentPost: PostCoreData?, coreData: CoreDataCoordinatorProtocol?, currentComment: CommentCoreData?) {

        self.currentPost = currentPost
        self.coreData = coreData
        self.currentComments = currentComment


    }

}




extension CommentTableViewCell {

    static var name: String {
        print("🫐", String(describing: self))
        return String(describing: self)
    }
}
