//
//  EditPostTextViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 13.02.2023.
//

import UIKit

class EditPostTextViewController: UIViewController {



    private var delegate: ProfileViewControllerDelegate?

    private var delegateAlternative: SavedPostsViewControllerDelegate?

    private var currentPost: PostCoreData?

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private lazy var barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(barButtonCancelAction))

    private lazy var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))

    private lazy var textViewPost = UITextView.setupTextView(text: currentPost?.text)

    init(currentPost: PostCoreData?, delegate: ProfileViewControllerDelegate?, delegateAlternative: SavedPostsViewControllerDelegate?, coreData: CoreDataCoordinatorProtocol?) {
        super.init(nibName: nil, bundle: nil)

        self.currentPost = currentPost
        self.delegate = delegate
        self.delegateAlternative = delegateAlternative
        self.coreDataCoordinator = coreData
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(textViewPost)
        navigationItem.leftBarButtonItem = barButtonCancel
        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        navigationItem.title = "Редактировать текст".allLocalizable

        setupConstrains()
    }

    

    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            textViewPost.topAnchor.constraint(equalTo: safeAria.topAnchor),
            textViewPost.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            textViewPost.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            textViewPost.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),
        ])
    }
    
    @objc func barButtonCancelAction() {

        delegate?.dismissController()
        delegateAlternative?.dismissController()
    }

    @objc func barButtonSaveAction() {

        currentPost?.text = textViewPost.text
        coreDataCoordinator?.savePersistentContainerContext()

        delegate?.dismissController()
        delegateAlternative?.dismissController()

    }

}
