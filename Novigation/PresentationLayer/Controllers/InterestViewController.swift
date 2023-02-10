//
//  InterestViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 07.02.2023.
//

import UIKit

class InterestViewController: UIViewController {


    private var currentProfile: ProfileCoreData?
    private var coreDataCoordinator: CoreDataCoordinatorProtocol?
    private var delegate: ProfileViewControllerDelegate?

    private lazy var tapBarButtonSave: UIBarButtonItem = {

        var tapBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(tapBarButtonSaveAction))

        return tapBarButton
    }()

    private lazy var labelInterest = UILabel.setupLabelBold(text: "labelInterest".allLocalizable )


    private lazy var textViewInterest: UITextView = CustomViews.setupTextView(text: currentProfile?.interest )


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

        [labelInterest, textViewInterest].forEach { view.addSubview($0) }

        setupConstrains()

    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            labelInterest.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 20),
            labelInterest.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textViewInterest.topAnchor.constraint(equalTo: labelInterest.bottomAnchor, constant: 10),
            textViewInterest.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textViewInterest.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textViewInterest.heightAnchor.constraint(equalToConstant: 270),
        ])
    }


    @objc private func tapBarButtonSaveAction() {

        currentProfile?.interest = textViewInterest.text
        coreDataCoordinator?.savePersistentContainerContext()
        navigationController?.popViewController(animated: true)
    }
}
