//
//  FeedViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 26.05.2022.
//

import UIKit

import StorageService

class FeedViewController: UIViewController {

    private var publisher: FeedModelPublisher?

    private lazy var viewCheckWord: CheckWord = {
        var viewCheckWord = CheckWord()
        viewCheckWord.backgroundColor = .systemGray5
        viewCheckWord.translatesAutoresizingMaskIntoConstraints = false
        viewCheckWord.layer.cornerRadius = 12
        return viewCheckWord
    }()

    private lazy var textFieldCheckWord: UITextField = {
        var textFieldCheckWord = UITextField()
        textFieldCheckWord.translatesAutoresizingMaskIntoConstraints = false
        textFieldCheckWord.clearButtonMode = .whileEditing
        textFieldCheckWord.backgroundColor = .systemGray5
        textFieldCheckWord.layer.cornerRadius = 12
        textFieldCheckWord.placeholder = "    Напиши слово"
        return  textFieldCheckWord
    }()

    private lazy var buttonCheckWord: CustomButton = {
        var buttonCheckWord = CustomButton("Проверить слово",
                                           color: .white,
                                           targetAction: {

            self.publisher?.check(self.textFieldCheckWord.text)
        },
                                           frame: CGRect())
        return buttonCheckWord.giveMeCustomButton()
    }()

    private lazy var postStack: UIStackView = {
        var postStack = UIStackView()
        postStack.backgroundColor = .white
        postStack.translatesAutoresizingMaskIntoConstraints = false
        postStack.axis = .vertical
        postStack.distribution = .fillEqually
        postStack.spacing = 10
        return postStack
    }()

    private lazy var buttonRightNavInfo: UIBarButtonItem = {
        var buttonRightNavInfo = UIBarButtonItem(title: "Информация", style: .done, target: self, action: #selector(actionButtonRightNavInfo))
        return buttonRightNavInfo
    }()

    private lazy var postButton: UIButton = {
        var postButton = UIButton()
        postButton.translatesAutoresizingMaskIntoConstraints = false
        postButton.backgroundColor = .systemYellow
        postButton.setTitle("Пост1", for: .normal)
        postButton.addTarget(self, action: #selector(didTapPostButton), for: .touchUpInside)
        return postButton
    }()

    private lazy var postButton2: UIButton = {
        var postButton2 = UIButton()
        postButton2.translatesAutoresizingMaskIntoConstraints = false
        postButton2.backgroundColor = .systemYellow
        postButton2.setTitle("Пост2", for: .normal)
        postButton2.addTarget(self, action: #selector(didTapPostButton2), for: .touchUpInside)
        return postButton2
    }()


    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        self.publisher = FeedModelPublisher()
        self.publisher?.add(subscriber: self)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.postButton.layer.cornerRadius = self.postButton.frame.height / 2
        self.postButton2.layer.cornerRadius = self.postButton2.frame.height / 2
    }

    private func setupView() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "Лента"
        self.view.addSubview(postStack)
        [viewCheckWord, textFieldCheckWord, buttonCheckWord, postButton, postButton2].forEach({ self.postStack.addArrangedSubview($0)})
        self.navigationItem.rightBarButtonItem = buttonRightNavInfo



        NSLayoutConstraint.activate([

            self.postStack.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.postStack.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.postStack.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            self.postStack.heightAnchor.constraint(equalToConstant: 300),
        ])
    }


    @objc private func didTapPostButton(){
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        if let title = postButton.titleLabel?.text {
            postViewController.post = Post(title: title)
        }
    }

    @objc private func didTapPostButton2() {
        let postViewController = PostViewController()
        self.navigationController?.pushViewController(postViewController, animated: true)
        if let title = postButton2.titleLabel?.text {
            postViewController.post = Post(title: title)
        }
    }

    @objc private func actionButtonRightNavInfo() {
        let navInfoViewController = UINavigationController(rootViewController: InfoViewController())
        present(navInfoViewController, animated: true, completion: nil)
    }

}

extension FeedViewController: FeedModelSubscribers {
    func changeTheColor(_ color: UIColor) {
        self.viewCheckWord.backgroundColor = color
    }


}


