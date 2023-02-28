//
//  MainInformationViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 01.02.2023.
//

import UIKit
import CoreData



class MainInformationViewController: UIViewController, KeyboardServiceProtocol {
  



    private var currentProfile: ProfileCoreData?

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var delegate: ProfileViewControllerDelegate

    private lazy var userPosts = coreDataCoordinator?.fetchedResultsControllerPostCoreData?.sections?.first?.objects as? [PostCoreData]


    private lazy var gestureRecognizerEndEditingInScrollView = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerEndEditingInScrollViewAction))


    private var scrollView: UIScrollView = {

        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()


    private lazy var barButtonSave: UIBarButtonItem = {

        var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))
        return barButtonSave
    }()


    private lazy var labelName = UILabel.setupLabelBold(text: "labelNameMainInformation".allLocalizable)

    private lazy var textFieldName = setupTextField(text: currentProfile?.name)

    private lazy var labelSurname = UILabel.setupLabelBold(text: "labelSurnameMainInformation".allLocalizable)

    private lazy var textFieldSurname = setupTextField(text: currentProfile?.surname)

    private lazy var labelGender = UILabel.setupLabelBold(text: "labelGenderMainInformation".allLocalizable)

    private lazy var viewManGender = setupViewGender("man")

    private lazy var gestureRecognizerGenderMan = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerGenderManAction))


    private var labelManGender: UILabel = {
        var labelManGender = UILabel()
        labelManGender.text = "labelManGender".allLocalizable
        labelManGender.translatesAutoresizingMaskIntoConstraints = false
        return labelManGender
    }()

    private lazy var viewWomanGender = setupViewGender("woman")

    private lazy var gestureRecognizerGenderWoman = UITapGestureRecognizer(target: self, action: #selector(gestureRecognizerGenderWomanAction))


    private var labelWomanGender: UILabel = {
        var labelWomanGender = UILabel()
        labelWomanGender.text = "labelWomanGender".allLocalizable
        labelWomanGender.translatesAutoresizingMaskIntoConstraints = false
        return labelWomanGender
    }()

    private lazy var labelBirthday = UILabel.setupLabelBold(text: "labelBirthday".allLocalizable)


    private lazy var datePicker: UIDatePicker = {
        var datePicker = UIDatePicker()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.datePickerMode = .date
        datePicker.date = loadDate() ?? Date()
        return datePicker
    }()


    private lazy var labelHometown = UILabel.setupLabelBold(text: "labelHometown".allLocalizable)


    private lazy var textFieldHometown = setupTextField(text: currentProfile?.hometown)


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

        view.addSubview(scrollView)

        [labelName, textFieldName, labelSurname, textFieldSurname, labelGender, viewManGender, labelManGender, viewWomanGender, labelWomanGender, labelBirthday, datePicker, labelHometown, textFieldHometown].forEach { scrollView.addSubview($0) }

        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        viewManGender.addGestureRecognizer(gestureRecognizerGenderMan)
        viewWomanGender.addGestureRecognizer(gestureRecognizerGenderWoman)
        scrollView.addGestureRecognizer(gestureRecognizerEndEditingInScrollView)

        setupConstraints()
        
        setupNotifications()
    }


    @objc private func gestureRecognizerGenderManAction() {

        viewManGender.backgroundColor = UIColor(named: "MyColorSet")

        viewWomanGender.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
    }

    
    @objc private func gestureRecognizerGenderWomanAction() {

        viewWomanGender.backgroundColor = UIColor(named: "MyColorSet")

        viewManGender.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
    }


    @objc private func gestureRecognizerEndEditingInScrollViewAction() {

        view.endEditing(true)
    }



    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)

    }


    private func setupNotifications() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowAction(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideAction), name: UIResponder.keyboardWillHideNotification, object: nil)
    }



    private func setupTextField(text: String?) -> UITextField {
        let textField = UITextField()
        textField.text = text
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.keyboardType = .namePhonePad
        return textField
    }



    private func setupViewGender(_ gender: String) -> UIView {
        let viewGender = UIView()

        if gender == currentProfile?.gender {
            viewGender.backgroundColor = UIColor(named: "MyColorSet")
        }

        viewGender.isUserInteractionEnabled = true

        viewGender.layer.cornerRadius = 10
        viewGender.translatesAutoresizingMaskIntoConstraints = false
        viewGender.layer.borderColor = UIColor(named: "MyColorSet")?.cgColor
        viewGender.layer.borderWidth = 2
        return viewGender
    }


    private func setupConstraints()  {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),

            labelName.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            labelName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
            textFieldName.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textFieldName.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),
            textFieldName.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            labelSurname.topAnchor.constraint(equalTo: textFieldName.bottomAnchor, constant: 20),
            labelSurname.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            textFieldSurname.topAnchor.constraint(equalTo: labelSurname.bottomAnchor, constant: 5),
            textFieldSurname.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textFieldSurname.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textFieldSurname.heightAnchor.constraint(equalToConstant: 40),

            labelGender.topAnchor.constraint(equalTo: textFieldSurname.bottomAnchor, constant: 20),
            labelGender.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            viewManGender.topAnchor.constraint(equalTo: labelGender.bottomAnchor, constant: 10),
            viewManGender.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewManGender.widthAnchor.constraint(equalToConstant: 20),
            viewManGender.heightAnchor.constraint(equalToConstant: 20),

            labelManGender.centerYAnchor.constraint(equalTo: viewManGender.centerYAnchor),
            labelManGender.leadingAnchor.constraint(equalTo: viewManGender.trailingAnchor, constant: 20),

            viewWomanGender.topAnchor.constraint(equalTo: viewManGender.bottomAnchor, constant: 20),
            viewWomanGender.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            viewWomanGender.widthAnchor.constraint(equalToConstant: 20),
            viewWomanGender.heightAnchor.constraint(equalToConstant: 20),

            labelWomanGender.centerYAnchor.constraint(equalTo: viewWomanGender.centerYAnchor),
            labelWomanGender.leadingAnchor.constraint(equalTo: viewWomanGender.trailingAnchor, constant: 20),

            labelBirthday.topAnchor.constraint(equalTo: labelWomanGender.bottomAnchor, constant: 20),
            labelBirthday.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            datePicker.topAnchor.constraint(equalTo: labelBirthday.bottomAnchor, constant: 10),
            datePicker.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            labelHometown.topAnchor.constraint(equalTo: datePicker.bottomAnchor, constant: 20),
            labelHometown.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),

            textFieldHometown.topAnchor.constraint(equalTo: labelHometown.bottomAnchor, constant: 5),
            textFieldHometown.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            textFieldHometown.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            textFieldHometown.heightAnchor.constraint(equalToConstant: 40),
            textFieldHometown.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
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




    @objc private func keyboardWillShowAction(_ notifications: Notification) {

        keyboardWillShow(notifications: notifications, view: view, viewScroll: scrollView, bottomElement: textFieldHometown, correction: nil)

    }



    @objc private func keyboardWillHideAction() {

        scrollView.contentOffset.y = 0.0
    }



    @objc private func barButtonSaveAction() {

        if self.viewManGender.backgroundColor == UIColor(named: "MyColorSet") {
            currentProfile?.gender = "man"
        }

        if self.viewWomanGender.backgroundColor == UIColor(named: "MyColorSet") {
            currentProfile?.gender = "woman"
        }

        if let userPosts {
            for post in userPosts {
                post.author = textFieldName.text
                post.surname = textFieldSurname.text
            }
        }

        currentProfile?.name = textFieldName.text
        currentProfile?.surname = textFieldSurname.text
        currentProfile?.birthday = self.saveDate()
        currentProfile?.hometown = textFieldHometown.text

        self.coreDataCoordinator?.savePersistentContainerContext()
        self.delegate.loadUserFromCoreData()
        self.navigationController?.popViewController(animated: true)

    }
}



