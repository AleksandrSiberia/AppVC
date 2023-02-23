//
//  EducationViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 06.02.2023.
//

import UIKit


class EducationViewController: UIViewController {

    private var currentProfile: ProfileCoreData?
    private var coreDataCoordinator: CoreDataCoordinatorProtocol?
    private var delegate: ProfileViewControllerDelegate?

    private lazy var tapBarButtonSave: UIBarButtonItem = {

        var tapBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapBarButtonSaveAction))

        return tapBarButton
    }()

    private lazy var labelEducations = UILabel.setupLabelBold(text: "labelEducations".allLocalizable )


    private lazy var textViewEducations = UITextView.setupTextView(text: currentProfile?.education)


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

        [labelEducations, textViewEducations].forEach { view.addSubview($0) }

        setupConstrains()

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            labelEducations.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 20),
            labelEducations.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textViewEducations.topAnchor.constraint(equalTo: labelEducations.bottomAnchor, constant: 10),
            textViewEducations.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textViewEducations.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textViewEducations.heightAnchor.constraint(equalToConstant: 270),
        ])
    }



    @objc private func tapBarButtonSaveAction() {

        currentProfile?.education = textViewEducations.text
        
        coreDataCoordinator?.savePersistentContainerContext()
        delegate?.loadUserFromCoreData()
        navigationController?.popViewController(animated: true)
    }
}

