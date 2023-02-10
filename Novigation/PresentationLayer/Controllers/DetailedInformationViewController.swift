//
//  DetailedInformationViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 08.02.2023.
//

import UIKit

class DetailedInformationViewController: UIViewController {

    private let currentProfile: ProfileCoreData?
    private let coreDataCoordinator: CoreDataCoordinatorProtocol?


    private lazy var barButtonItemCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(barButtonItemCancelAction))


    private var scrollView: UIScrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()



    private var imageViewCareer = UIImageView.setupImageView(systemName: "message")
    private lazy var labelCareer = UILabel.setupLabelRegular(text: currentProfile?.career ?? "")

    private var imageViewCity = UIImageView.setupImageView(systemName: "house")
    private lazy var labelCity = UILabel.setupLabelRegular(text: currentProfile?.hometown ?? "")

    private var imageViewEducations = UIImageView.setupImageView(systemName: "graduationcap.fill")
    private lazy var labelEducations = UILabel.setupLabelRegular(text: currentProfile?.education ?? "")

    private var imageViewContacts = UIImageView.setupImageView(systemName: "phone")
    private lazy var labelContacts = UILabel.setupLabelRegular(text: currentProfile?.mobilePhone ?? "")

    private var imageViewInterest = UIImageView.setupImageView(systemName: "basketball")
    private lazy var labelInterest = UILabel.setupLabelRegular(text: currentProfile?.interest ?? "")



    init(currentProfile: ProfileCoreData?, coreData: CoreDataCoordinatorProtocol?) {
        self.currentProfile = currentProfile
        self.coreDataCoordinator = coreData
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()

        navigationItem.leftBarButtonItem = barButtonItemCancel

        navigationItem.title = "buttonDetailedInformations".allLocalizable

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
        
    }



    private func setupView() {

        view.addSubview(scrollView)

        let arrayImageView = [imageViewCareer,
                              imageViewCity,
                              imageViewEducations,
                              imageViewContacts,
                              imageViewInterest
        ]

        let arrayLabel = [labelCareer,
                          labelCity,
                          labelEducations,
                          labelContacts,
                          labelInterest]

        arrayImageView.forEach { scrollView.addSubview($0) }
        arrayLabel.forEach { scrollView.addSubview($0)   }

        setupConstraints(arrayImageView: arrayImageView, arrayLabel: arrayLabel)
    }



    private func setupConstraints(arrayImageView: [UIImageView], arrayLabel: [UILabel]) {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),
        ])

        guard arrayImageView.count == arrayLabel.count else {
            print("‼️ arrayImageView.count != arrayLabel.count")
            return
        }

        for (index, imageView) in arrayImageView .enumerated() {

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 30),
                imageView.heightAnchor.constraint(equalToConstant: 30),
                imageView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
                imageView.centerYAnchor.constraint(equalTo: arrayLabel[index].centerYAnchor),
            ])
        }

        for (index, label) in arrayLabel .enumerated() {

            if index == 0 {
                NSLayoutConstraint.activate([

                    label.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 15),
                    label.leadingAnchor.constraint(equalTo: arrayImageView[0].trailingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
                ])
            }

            else {
                NSLayoutConstraint.activate([
                    label.topAnchor.constraint(equalTo: arrayLabel[index - 1].bottomAnchor, constant: 25),
                    label.leadingAnchor.constraint(equalTo: arrayImageView[index].trailingAnchor, constant: 10),
                    label.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15)
                ])
            }
        }
    }



    @objc private func barButtonItemCancelAction() {

        dismiss(animated: true)
    }

}
