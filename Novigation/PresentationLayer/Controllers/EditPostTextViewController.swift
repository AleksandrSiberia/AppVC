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
    private var delegateFVC: FeedViewControllerDelegate?


    private var currentPost: PostCoreData?

    private var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private var scrollView: UIScrollView = {

        var scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()


    private lazy var barButtonCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(barButtonCancelAction))

    private lazy var barButtonSave = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(barButtonSaveAction))

    private lazy var textViewPost = UITextView.setupTextView(text: currentPost?.text)



    init(currentPost: PostCoreData?, delegate: ProfileViewControllerDelegate?, delegateAlternative: SavedPostsViewControllerDelegate?, delegateFVC: FeedViewControllerDelegate?, coreData: CoreDataCoordinatorProtocol?) {
        super.init(nibName: nil, bundle: nil)

        self.currentPost = currentPost
        self.delegate = delegate
        self.delegateAlternative = delegateAlternative
        self.coreDataCoordinator = coreData
        self.delegateFVC = delegateFVC


    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.addSubview(textViewPost)

        navigationItem.leftBarButtonItem = barButtonCancel
        navigationItem.rightBarButtonItem = barButtonSave

        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        navigationItem.title = "Редактировать текст".allLocalizable

        setupConstrains()
    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),

            textViewPost.topAnchor.constraint(equalTo: scrollView.topAnchor),
            textViewPost.widthAnchor.constraint(equalTo: safeAria.widthAnchor),
            textViewPost.heightAnchor.constraint(equalToConstant: 330),
            textViewPost.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),

        ])
    }


    
    @objc func barButtonCancelAction() {

        delegate?.dismissController()
        delegateAlternative?.dismissController()
        delegateFVC?.dismissController()
    }

    @objc func barButtonSaveAction() {

        currentPost?.text = textViewPost.text
        coreDataCoordinator?.savePersistentContainerContext()

        delegate?.dismissController()
        delegateAlternative?.dismissController()
        delegateFVC?.dismissController()

    }

}
