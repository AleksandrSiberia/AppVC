//
//  FeedViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 26.05.2022.
//

import UIKit
import RealmSwift
import SwiftUI
import CoreData



class FeedViewController: UIViewController, ViewControllersDelegate {


    private var arrayCells: [PostCell] = []

    var coreData: CoreDataCoordinatorProtocol?

    
    private lazy var buttonVideoPlayer: UIButton = {

        let action = UIAction() { _ in

            let videoViewController = VideoViewController()
            self.present(videoViewController, animated: true)


            let image = UIImage(systemName: "video.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

            self.buttonVideoPlayer.setImage(image, for: .normal)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                let image = UIImage(systemName: "video", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

                self.buttonVideoPlayer.setImage(image, for: .normal)

            }

        }

        var button = UIButton(frame: CGRect(), primaryAction: action)

        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(systemName: "video", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)

        button.tintColor = UIColor.createColorForTheme(lightTheme: .gray, darkTheme: .white)

        return button
    }()



    private lazy var buttonAudioPlayer: UIButton = {

        let action = UIAction() { _ in

            let audioViewController = AudioViewController()
            self.present(audioViewController, animated: true)

            let image = UIImage(systemName: "headphones.circle.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

            self.buttonAudioPlayer.setImage(image, for: .normal)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

                let image = UIImage(systemName: "headphones.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

                self.buttonAudioPlayer.setImage(image, for: .normal)
            }

        }

        var button = UIButton(frame: CGRect(), primaryAction: action)

        button.translatesAutoresizingMaskIntoConstraints = false

        let image = UIImage(systemName: "headphones.circle", withConfiguration: UIImage.SymbolConfiguration(scale: .large))?.withRenderingMode(.alwaysTemplate)

        button.setImage(image, for: .normal)

        button.tintColor = UIColor.createColorForTheme(lightTheme: .gray, darkTheme: .white)

        return button
    }()



    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")

        tableView.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        return tableView
    }()




    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        self.navigationItem.title = "navigationItem.title".feedViewControllerLocalizable

        self.coreData?.fetchedResultsControllerPostCoreData?.delegate = self

        [buttonVideoPlayer, buttonAudioPlayer, tableView].forEach{ view.addSubview($0) }

        setupConstrains()
    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        self.view.endEditing(true)
    }



    private func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([

            buttonVideoPlayer.topAnchor.constraint(equalTo: safeAria.topAnchor),
            buttonVideoPlayer.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor, constant: 30),

            buttonAudioPlayer.centerYAnchor.constraint(equalTo: buttonVideoPlayer.centerYAnchor),
            buttonAudioPlayer.leadingAnchor.constraint(equalTo: buttonVideoPlayer.trailingAnchor, constant: 20),

            tableView.topAnchor.constraint(equalTo: buttonVideoPlayer.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor),

        ])
    }


    func showMassage(text: String) {

        let alert = UIAlertController(title: nil, message: text, preferredStyle: .actionSheet)

        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
        }
    }


    func dismissController() {
        dismiss(animated: true)
    }

    func beginUpdatesTableView() {
        tableView.beginUpdates()
    }

    func endUpdatesTableView() {
        tableView.endUpdates()
    }

    func reloadTableView() {
        tableView.reloadData()
    }


    func showEditPostTextViewController(currentPost: PostCoreData?) {

        let controller = EditPostTextViewController(currentPost: currentPost, delegate: self, coreData: coreData)

        let navController = UINavigationController(rootViewController: controller)

        present(navController, animated: true)
    }
}




extension String {
    var feedViewControllerLocalizable: String {
        NSLocalizedString(self, tableName: "FeedViewControllerLocalizable", comment: "")
    }
}



extension FeedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if let section = coreData?.fetchedResultsControllerPostCoreData?.sections, section.isEmpty == false, let array = section.first  {


            return array.numberOfObjects
        }

        return 0
    }



    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }

        guard let section = coreData?.fetchedResultsControllerPostCoreData?.sections, section.isEmpty == false, let arrayPosts = section.first, arrayPosts.numberOfObjects - 1 >= indexPath.row, let post = arrayPosts.objects?[indexPath.row] as? PostCoreData

        else { return UITableViewCell() }

        if arrayCells.count - 1 >= indexPath.row {
            arrayCells.remove(at: indexPath.row)
            arrayCells.insert(cell, at: indexPath.row)
        }

        else {
            if arrayCells.count - 1 >= indexPath.row {
                arrayCells.insert(cell, at: indexPath.row)
            }
            else {
                arrayCells.insert(cell, at: arrayCells.endIndex)
            }
        }

        cell.setupCell(post: post, coreDataCoordinator: coreData, delegate: self)

        return cell
    }


    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
        arrayCells.forEach { $0.viewEditPostIsHidden() }
    }
}


extension FeedViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        tableView.reloadData()
    }
}
