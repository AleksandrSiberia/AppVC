//
//  ViewEditPost.swift
//  Novigation
//
//  Created by Александр Хмыров on 12.02.2023.
//

import Foundation
import UIKit


class ViewEditPost: UIView {

    private var arrayNamesCell = ["Сохранить в избранное".allLocalizable]
    private var arrayImageCell = [""]

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


extension ViewEditPost: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        arrayNamesCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)

        var contentConfiguration = cell.defaultContentConfiguration()

        contentConfiguration.text = arrayNamesCell[indexPath.row]

        let image = UIImage(systemName: arrayImageCell[indexPath.row])?.withRenderingMode(.alwaysTemplate)
        contentConfiguration.image = image

        cell.contentConfiguration = contentConfiguration
        cell.tintColor = .black

        cell.backgroundColor = UIColor.createColorForTheme(lightTheme: .systemGray6, darkTheme: .gray)


        return cell
    }


}
