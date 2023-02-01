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

    private lazy var barButtonSave: UIBarButtonItem = {

        var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))
        return barButtonSave
    }()



    private var labelName: UILabel = {

        var labelName = UILabel()
        labelName.text = "labelNameMainInformation".allLocalizable
        labelName.translatesAutoresizingMaskIntoConstraints = false
        labelName.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return labelName
    }()


    
    private lazy var textFieldName: UITextField = {
        
        var textFieldName = UITextField()
        textFieldName.text = currentProfile?.name
        textFieldName.translatesAutoresizingMaskIntoConstraints = false
        textFieldName.backgroundColor = .systemGray6
        textFieldName.layer.cornerRadius = 12
        return textFieldName
    }()



    init(profile: ProfileCoreData?) {
        super.init(nibName: nil, bundle: nil)

        self.currentProfile = profile

    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }



    override func viewDidLoad() {
        super.viewDidLoad()

        [labelName, textFieldName].forEach { view.addSubview($0) }

        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        setupConstraints()
    }



    private func setupConstraints()  {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            labelName.topAnchor.constraint(equalTo: safeAria.topAnchor),
            labelName.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),

            textFieldName.topAnchor.constraint(equalTo: labelName.bottomAnchor, constant: 5),
            textFieldName.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 15),
            textFieldName.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor, constant: -15),
            textFieldName.heightAnchor.constraint(equalToConstant: 40),

        ])

    }


    @objc private func barButtonSaveAction() {

        print("save")
    }


}
