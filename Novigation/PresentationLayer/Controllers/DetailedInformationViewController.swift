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


    private var scrollView = {
        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()



    private lazy var imageViewCareer = CustomViews.setupImageView(systemName: "message")

    private lazy var imageViewCity = CustomViews.setupImageView(systemName: "house")

    private lazy var imageViewEducations = CustomViews.setupImageView(systemName: "graduationcap.fill")

    private lazy var imageViewContacts = CustomViews.setupImageView(systemName: "phone")

    private lazy var imageViewInterest = CustomViews.setupImageView(systemName: "basketball")


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

        navigationItem.rightBarButtonItem = barButtonItemCancel

        navigationItem.title = "buttonDetailedInformations".allLocalizable

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)


    }



    private func setupView() {

        view.addSubview(scrollView)

        let arrayImageView = [imageViewCareer, imageViewCity, imageViewEducations, imageViewContacts, imageViewInterest]

        arrayImageView.forEach {
            scrollView.addSubview($0)
        }

        setupConstraints(arrayImageView: arrayImageView)
    }



    private func setupConstraints(arrayImageView: [UIImageView]) {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAria.topAnchor, constant: 15),
            scrollView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor, constant: -15),
        ])

        for (index, imageView) in arrayImageView .enumerated() {

            NSLayoutConstraint.activate([
                imageView.widthAnchor.constraint(equalToConstant: 30),
                imageView.heightAnchor.constraint(equalToConstant: 30),
            ])

            if index == 0 {
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                    imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
                ])
            }

            else {
                NSLayoutConstraint.activate([
                    imageView.topAnchor.constraint(equalTo: arrayImageView[index - 1].bottomAnchor, constant: 20.0),
                    imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
                ])
            }
        }
    }



    @objc private func barButtonItemCancelAction() {

        dismiss(animated: true)
    }

}
