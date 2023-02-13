//
//  ViewEditPost.swift
//  Novigation
//
//  Created by Александр Хмыров on 12.02.2023.
//

import Foundation
import UIKit


class ViewEditPost: UIView {

    var delegate: ProfileViewControllerDelegate?

    var delegateAlternative: SavedPostsViewControllerDelegate?

    var currentPost: PostCoreData? {
        willSet {
            tableView.reloadData()
        }
    }

    var coreDataCoordinator: CoreDataCoordinatorProtocol?


    private var arrayNamesCell = ["Сохранить в избранное".allLocalizable,
                                  "Редактировать текст".allLocalizable,
    ]
    private var arrayImageCell = ["bookmark",
                                  "pencil.line",

    ]

    private lazy var tableView: UITableView = {

        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.createColorForTheme(lightTheme: .systemGray6, darkTheme: .gray)

        tableView.register( UITableViewCell.self, forCellReuseIdentifier: "Default")
        return tableView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(tableView)
        setupConstrains()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    


    func setupConstrains() {

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}


extension ViewEditPost: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        arrayNamesCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)

        var contentConfiguration = cell.defaultContentConfiguration()

        contentConfiguration.text = {

            if indexPath.row == 0 {
                if currentPost?.favourite == "save" {

                    return "Убрать из сохраненного".allLocalizable
                }
                else {
                    return arrayNamesCell[indexPath.row]
                }
        }
            else {

                return arrayNamesCell[indexPath.row]
            }
        }()

        let image: UIImage? = {

            if indexPath.row == 0 {
                if currentPost?.favourite == "save" {

                    return UIImage(systemName:"bookmark.slash")
                }
                else {
                    return UIImage(systemName: arrayImageCell[indexPath.row])
                }
            }
            else {
                return UIImage(systemName: arrayImageCell[indexPath.row])
            }
        }()

        image?.withRenderingMode(.alwaysTemplate)

        contentConfiguration.image = image

        cell.contentConfiguration = contentConfiguration
        cell.tintColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)

        cell.backgroundColor = UIColor.createColorForTheme(lightTheme: .systemGray6, darkTheme: .gray)

        return cell
    }
}



extension ViewEditPost: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {



        switch indexPath.row {

        case 0:
            if currentPost?.favourite == "save" {
                currentPost?.favourite = nil
                coreDataCoordinator?.savePersistentContainerContext()
                self.isHidden = true

                delegate?.showMassage(text: "Пост убран из избранного".allLocalizable)

            }
            else {
                currentPost?.favourite = "save"
                coreDataCoordinator?.savePersistentContainerContext()
                self.isHidden = true

                delegate?.showMassage(text: "Пост добавлен в избранное".allLocalizable)
            }

            
        case 1:

            self.isHidden = true
            delegate?.showEditPostTextViewController(currentPost: currentPost)
            delegateAlternative?.showEditPostTextViewController(currentPost: currentPost)


        default:
            tableView.reloadData()
        }
    }
}
