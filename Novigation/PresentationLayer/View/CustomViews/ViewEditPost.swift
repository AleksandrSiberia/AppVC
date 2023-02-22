//
//  ViewEditPost.swift
//  Novigation
//
//  Created by Александр Хмыров on 12.02.2023.
//

import Foundation
import UIKit


class ViewEditPost: UIView {

    var delegate: ViewControllersDelegate?

    
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

    private lazy var buttonCancel: UIButton = {

        let action = UIAction() { _ in

            self.buttonCancel.setImage(UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate), for: .normal)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.isHidden = true

                self.buttonCancel.setImage(UIImage(systemName: "xmark.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate), for: .normal)

            }

        }

        var buttonCancel = UIButton(primaryAction: action)
        buttonCancel.translatesAutoresizingMaskIntoConstraints = false

        let symbolConfiguration = UIImage.SymbolConfiguration(scale: .large)

        let image = UIImage(systemName: "xmark.circle", withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)

        buttonCancel.setImage(image, for: .normal)

        buttonCancel.tintColor = UIColor.createColorForTheme(lightTheme: .black, darkTheme: .white)

        return buttonCancel
    }()




    private lazy var tableView: UITableView = {

        var tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false

        tableView.register( UITableViewCell.self, forCellReuseIdentifier: "Default")
        return tableView
    }()


    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor.gray.withAlphaComponent(0.5)
        layer.cornerRadius = 15

        backgroundColor = UIColor.createColorForTheme(lightTheme: UIColor.systemGray6.withAlphaComponent(0.85), darkTheme: UIColor.gray.withAlphaComponent(0.85))
        tableView.backgroundColor = UIColor.white.withAlphaComponent(0)

        addSubview(buttonCancel)
        addSubview(tableView)
        setupConstrains()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupConstrains() {

        NSLayoutConstraint.activate([

            buttonCancel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            buttonCancel.centerXAnchor.constraint(equalTo: centerXAnchor),

            tableView.topAnchor.constraint(equalTo: buttonCancel.bottomAnchor),
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

        cell.backgroundColor = UIColor.white.withAlphaComponent(0)
   //     UIColor.createColorForTheme(lightTheme: .systemGray6, darkTheme: .gray)

        cell.selectionStyle = .none

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
                delegate?.reloadTableView()


            }
            else {
                currentPost?.favourite = "save"
                coreDataCoordinator?.savePersistentContainerContext()
                self.isHidden = true

                delegate?.showMassage(text: "Пост добавлен в избранное".allLocalizable)
                delegate?.reloadTableView()
            }

            
        case 1:

            self.isHidden = true
            delegate?.showEditPostTextViewController(currentPost: currentPost)
          


        default:
            tableView.reloadData()
        }
    }
}
