//
//  ContactsViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 07.02.2023.
//

import UIKit

class ContactsViewController: UIViewController {

    private var currentProfile: ProfileCoreData?
    private var coreDataCoordinator: CoreDataCoordinatorProtocol?
    private var delegate: ProfileViewControllerDelegate?

    private lazy var tapBarButtonSave: UIBarButtonItem = {

        var tapBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapBarButtonSaveAction))

        return tapBarButton
    }()

    private lazy var labelMobilePhone = UILabel.setupLabelBold(text: "labelMobilePhone".allLocalizable )


    private lazy var textFieldMobilePhone = CustomViews.setupTextField(text: currentProfile?.mobilePhone, keyboardType: .numberPad)


    init(profile: ProfileCoreData?, coreDataCoordinator: CoreDataCoordinatorProtocol?, delegate: ProfileViewControllerDelegate) {

        self.currentProfile = profile
        self.coreDataCoordinator = coreDataCoordinator
        self.delegate = delegate

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = tapBarButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        [labelMobilePhone, textFieldMobilePhone].forEach { view.addSubview($0) }

        setupConstrains()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }



    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            labelMobilePhone.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 20),
            labelMobilePhone.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textFieldMobilePhone.topAnchor.constraint(equalTo: labelMobilePhone.bottomAnchor, constant: 5),
            textFieldMobilePhone.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textFieldMobilePhone.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textFieldMobilePhone.heightAnchor.constraint(equalToConstant: 40),

        ])
    }


    @objc private func tapBarButtonSaveAction() {

        currentProfile?.mobilePhone = textFieldMobilePhone.text
        coreDataCoordinator?.savePersistentContainerContext()
        delegate?.loadUserFromCoreData()
        navigationController?.popViewController(animated: true)
    }

}
