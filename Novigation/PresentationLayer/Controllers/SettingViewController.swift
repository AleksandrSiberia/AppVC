//
//  SettingViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 31.01.2023.
//

import UIKit
import KeychainSwift
import CoreData

class SettingViewController: UIViewController {


    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var currentProfile: ProfileCoreData?

    private var delegate: ProfileViewControllerDelegate

    private lazy var barButtonItemCancel: UIBarButtonItem = {
        var barButtonItemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(barButtonItemCancelAction) )
        return barButtonItemCancel
    }()


    
    private lazy var namesCells = ["Основная информация".allLocalizable,
                                   "Образование".allLocalizable,
                                   "Карьера".allLocalizable,
                                   "Интересы".allLocalizable,
                                   "Контакты".allLocalizable
    ]


    private lazy var tableView: UITableView = {
        var tableView = UITableView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self 
        return tableView
    }()


    private lazy var nameUser: UILabel = {

        var nameUser = UILabel()
        nameUser.text = "nameUser".allLocalizable
        return nameUser
    }()


    private lazy var buttonExit: UIButton = {
        let buttonExit = UIButton()
        let screen = UIScreen.main.bounds.width
        let screenH = UIScreen.main.bounds.height

        buttonExit.frame = CGRect(x: 20, y: screenH / 2, width: screen - 40, height: 30)
        buttonExit.backgroundColor = .systemPink
        buttonExit.addTarget(self, action: #selector(didTagButton), for: .touchUpInside)
        buttonExit.setTitle( NSLocalizedString("buttonExit", tableName: "InfoViewControllerLocalizable", comment: ""), for: .normal)
        buttonExit.layer.cornerRadius = 10
        buttonExit.clipsToBounds = true
        return buttonExit
    }()



    init(coreData: CoreDataCoordinatorProtocol, delegate: ProfileViewControllerDelegate) {
        self.coreDataCoordinator = coreData
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        navigationItem.title = NSLocalizedString("navigationItem.title", tableName: "InfoViewControllerLocalizable", comment: "Настройки")


        coreDataCoordinator?.getCurrentProfile { currentProfile in
            self.currentProfile = currentProfile
        }
        addSubview()
        setupConstrains()

    }


    func addSubview() {
        navigationItem.leftBarButtonItem = barButtonItemCancel
        view.addSubview(tableView)
        view.addSubview(buttonExit)
    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            tableView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),

            buttonExit.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15),
            buttonExit.centerXAnchor.constraint(equalTo: view.centerXAnchor),

        ])
    }


    @objc private func barButtonItemCancelAction() {
        dismiss(animated: true)
    }


    @objc private func didTagButton() {

        let alertExit = UIAlertController(title: nil, message: NSLocalizedString("buttonExitAlertExit", tableName: "InfoViewControllerLocalizable", comment: "Выйти из аккаунта?"), preferredStyle: .alert)

        let cancelAction = UIAlertAction(title: NSLocalizedString("buttonExitCancelAction", tableName: "InfoViewControllerLocalizable", comment: ""),
                                         style: .cancel,
                                         handler: {_ in
        })
        alertExit.addAction(cancelAction)

        let exitAction = UIAlertAction(title: NSLocalizedString("buttonExitExitAction", tableName: "InfoViewControllerLocalizable", comment: ""),
                                         style: .destructive,
                                         handler: {_ in


            KeychainSwift().delete("userOnline")
            self.dismiss(animated: true)

        })
        alertExit.addAction(exitAction)
        present(alertExit, animated: true)
    }
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        namesCells.count
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)

        var content = cell.defaultContentConfiguration()

        content.text = namesCells[indexPath.row]
        content.image = UIImage(systemName: "chevron.right")

        cell.contentConfiguration = content

        return cell
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let navigationBarTitle = namesCells[indexPath.row]


        switch indexPath.row {
        case 0:

            let vc = MainInformationViewController(profile: currentProfile, coreDataCoordinator: self.coreDataCoordinator, delegate: self.delegate)

            vc.navigationItem.title = navigationBarTitle
            navigationController?.pushViewController(vc, animated: true)

        case 1:
            print(navigationBarTitle)
        case 2:
            print(navigationBarTitle)
        case 3:
            print(navigationBarTitle)
        case 4:
            print(navigationBarTitle)
        default:
            print("‼️ this page does not exist")
        }
    }


}
