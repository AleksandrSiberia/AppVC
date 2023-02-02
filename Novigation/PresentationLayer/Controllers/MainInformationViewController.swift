//
//  MainInformationViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 01.02.2023.
//

import UIKit
import CoreData


class MainInformationViewController: UIViewController {


    private var currentProfile: ProfileCoreData?

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private lazy var barButtonSave: UIBarButtonItem = {

        var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))
        return barButtonSave
    }()

    private lazy var labelName = setupLabel(text: "labelNameMainInformation".allLocalizable)

    private lazy var textFieldName = setupTextField(text: currentProfile?.name)

    private lazy var labelSurname = setupLabel(text: "labelSurnameMainInformation".allLocalizable)

    private lazy var textFieldSurname = setupTextField(text: currentProfile?.surname)



    init(profile: ProfileCoreData?, coreDataCoordinator: CoreDataCoordinatorProtocol?) {
        super.init(nibName: nil, bundle: nil)

        self.currentProfile = profile
        self.coreDataCoordinator = coreDataCoordinator

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        [labelName, textFieldName, labelSurname, textFieldSurname].forEach { view.addSubview($0) }

        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        setupConstraints()
    }


    private func setupTextField(text: String?) -> UITextField {

            let textField = UITextField()
            textField.text = text
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.backgroundColor = .systemGray6
            textField.layer.cornerRadius = 12
            return textField
    }


    private func setupLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }


    private func setupConstraints()  {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            labelName.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
            textFieldName.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textFieldName.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),

            labelSurname.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            labelSurname.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textFieldSurname.topAnchor.constraint(equalTo: labelSurname.bottomAnchor, constant: 5),
            textFieldSurname.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textFieldSurname.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textFieldSurname.heightAnchor.constraint(equalToConstant: 40),

        ])

    }




    @objc private func barButtonSaveAction() {

        let values = ["email": currentProfile?.email ?? "",
                      "name": textFieldName.text ?? "",
                      "status": "Test",
                      "avatar": "avatar",
                      "surname": textFieldSurname.text ?? ""
        ]


        coreDataCoordinator?.deleteCurrentProfile { _ in

            self.coreDataCoordinator?.appendProfile(values: values)
        }




    }


}
