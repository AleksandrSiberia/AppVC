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

    private var delegate: ProfileViewControllerDelegate



    private lazy var barButtonSave: UIBarButtonItem = {

        var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))
        return barButtonSave
    }()

    private lazy var labelName = setupLabel(text: "labelNameMainInformation".allLocalizable)

    private lazy var textFieldName = setupTextField(text: currentProfile?.name)

    private lazy var labelSurname = setupLabel(text: "labelSurnameMainInformation".allLocalizable)

    private lazy var textFieldSurname = setupTextField(text: currentProfile?.surname)

    private lazy var labelGender = setupLabel(text: "labelGenderMainInformation".allLocalizable)

    private lazy var viewManGender = setupViewGender("man")

    private var labelManGender: UILabel = {
        var labelManGender = UILabel()
        labelManGender.text = "labelManGender".allLocalizable
        labelManGender.translatesAutoresizingMaskIntoConstraints = false
        return labelManGender
    }()

    private lazy var viewWomanGender = setupViewGender("woman")

    private var labelWomanGender: UILabel = {
        var labelWomanGender = UILabel()
        labelWomanGender.text = "labelWomanGender".allLocalizable
        labelWomanGender.translatesAutoresizingMaskIntoConstraints = false
        return labelWomanGender
    }()

    private lazy var labelBirthday = setupLabel(text: "labelBirthday".allLocalizable)


    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.date = loadDate() ?? Date()
        return datePicker
    }()


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

        [labelName, textFieldName, labelSurname, textFieldSurname, labelGender, viewManGender, labelManGender, viewWomanGender, labelWomanGender, labelBirthday, datePicker].forEach { view.addSubview($0) }

        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        setupConstraints()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        let touch = touches.first


        if touch?.view == viewManGender {

            viewManGender.backgroundColor = UIColor(named: "MyColorSet")

            viewWomanGender.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
        }

        if touch?.view == viewWomanGender {

            viewWomanGender.backgroundColor = UIColor(named: "MyColorSet")
            viewManGender.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
        }
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


    private func setupViewGender(_ gender: String) -> UIView {
        let viewGender = UIView()

        if gender == currentProfile?.gender {
            viewGender.backgroundColor = UIColor(named: "MyColorSet")
        }

        viewGender.layer.cornerRadius = 10
        viewGender.translatesAutoresizingMaskIntoConstraints = false
        viewGender.layer.borderColor = UIColor(named: "MyColorSet")?.cgColor
        viewGender.layer.borderWidth = 2
        return viewGender
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

            labelGender.topAnchor.constraint(equalTo: textFieldSurname.bottomAnchor, constant: 20),
            labelGender.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            viewManGender.topAnchor.constraint(equalTo: labelGender.bottomAnchor, constant: 10),
            viewManGender.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            viewManGender.widthAnchor.constraint(equalToConstant: 20),
            viewManGender.heightAnchor.constraint(equalToConstant: 20),

            labelManGender.centerYAnchor.constraint(equalTo: viewManGender.centerYAnchor),
            labelManGender.leadingAnchor.constraint(equalTo: viewManGender.trailingAnchor, constant: 20),

            viewWomanGender.topAnchor.constraint(equalTo: viewManGender.bottomAnchor, constant: 20),
            viewWomanGender.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            viewWomanGender.widthAnchor.constraint(equalToConstant: 20),
            viewWomanGender.heightAnchor.constraint(equalToConstant: 20),

            labelWomanGender.centerYAnchor.constraint(equalTo: viewWomanGender.centerYAnchor),
            labelWomanGender.leadingAnchor.constraint(equalTo: viewWomanGender.trailingAnchor, constant: 20),

            labelBirthday.topAnchor.constraint(equalTo: labelWomanGender.bottomAnchor, constant: 20),
            labelBirthday.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            datePicker.topAnchor.constraint(equalTo: labelBirthday.bottomAnchor, constant: 20),
            datePicker.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 5),
        ])
    }


    private func saveDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let dateString = dateFormatter.string(from: datePicker.date)
        return dateString
    }


    private func loadDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.date(from: currentProfile?.birthday ?? "")
    }


    @objc private func barButtonSaveAction() {

        coreDataCoordinator?.getCurrentProfile { profile in

            if let name = self.textFieldName.text, let surname = self.textFieldSurname.text {

                if self.viewManGender.backgroundColor == UIColor(named: "MyColorSet") {
                    profile?.gender = "man"
                }

                if self.viewWomanGender.backgroundColor == UIColor(named: "MyColorSet") {
                    profile?.gender = "woman"
                }

                profile?.name = name
                profile?.surname = surname
                profile?.birthday = self.saveDate()

                self.coreDataCoordinator?.savePersistentContainerContext()
                self.delegate.loadUserFromCoreData()
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}



