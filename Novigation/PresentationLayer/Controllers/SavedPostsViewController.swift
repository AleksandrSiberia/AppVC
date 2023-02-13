//
//  SavedPostsViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 04.11.2022.
//

import UIKit
import CoreData


protocol SavedPostsViewControllerDelegate {

    func showEditPostTextViewController(currentPost: PostCoreData?)
    func dismissController()
}



class SavedPostsViewController: UIViewController, SavedPostsViewControllerDelegate {



    var coreDataCoordinator: CoreDataCoordinatorProtocol!

    private var nameAuthor: String = ""

    private var textFieldSearchAuthor: UITextField?

    private lazy var barButtonItemSearch: UIBarButtonItem = {
        var barButtonItemSearch = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(actionBarButtonItemSearch))
        return barButtonItemSearch
    }()




    private lazy var barButtonItemCancelSearch: UIBarButtonItem = {
        var barButtonItemCancelSearch = UIBarButtonItem(image: UIImage( systemName: "minus.circle"), style: .plain, target: self, action: #selector(actionBarButtonItemCancelSearch))
        return barButtonItemCancelSearch
    }()




    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")

        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")

        tableView.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        return tableView
    }()




    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        self.navigationItem.title = NSLocalizedString("navigationItem.title", tableName: "SavedPostsViewControllerLocalizable", comment: "Saved posts")

        self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.delegate = self

        self.navigationItem.rightBarButtonItems = [self.barButtonItemCancelSearch, self.barButtonItemSearch ]
        self.view.addSubview(self.tableView)

        setupConstrains()

    }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.coreDataCoordinator.performFetchSavePostCoreData()

    }


    func setupConstrains() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor)
        ])
    }


    func showEditPostTextViewController(currentPost: PostCoreData?) {

        let controller = EditPostTextViewController(currentPost: currentPost, delegate: nil, delegateAlternative: self, coreData: coreDataCoordinator)
        let navController = UINavigationController(rootViewController: controller)

        present(navController, animated: true)
    }

    func dismissController() {

        dismiss(animated: true)
    }



    @objc private func actionBarButtonItemSearch() {


        let alert = UIAlertController(title: nil, message: NSLocalizedString("actionBarButtonItemSearchAlert", tableName: "SavedPostsViewControllerLocalizable", comment: "Напишите имя автора") , preferredStyle: .alert)


        alert.addTextField { textField in

            textField.clearButtonMode = .whileEditing
            self.textFieldSearchAuthor = textField
        }

        let actionSearch = UIAlertAction(title: NSLocalizedString("actionBarButtonItemSearchAlertActionSearch", tableName: "SavedPostsViewControllerLocalizable", comment: "Найти") , style: .default) {action in

            if self.textFieldSearchAuthor?.text != "" {

                self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.fetchRequest.predicate = NSPredicate(format: "author contains[c] %@", self.textFieldSearchAuthor?.text ?? "")

                self.coreDataCoordinator.performFetchSavePostCoreData()

                self.tableView.reloadData()
            }
        }

        let actionCancel = UIAlertAction(title: NSLocalizedString("actionBarButtonItemSearchAlertActionCancel", tableName: "SavedPostsViewControllerLocalizable", comment: "Отмена"), style: .cancel)

        alert.addAction(actionCancel)
        alert.addAction(actionSearch)

        present(alert, animated: true)
    }



    @objc private func actionBarButtonItemCancelSearch() {


        self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.fetchRequest.predicate = NSPredicate(format: "favourite = %@", "save")

        self.coreDataCoordinator.performFetchSavePostCoreData()

        self.tableView.reloadData()
    }
}





extension SavedPostsViewController: UITableViewDelegate, UITableViewDataSource  {


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        print("🌵", self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.sections?[0].numberOfObjects ?? 0)
        return self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.sections?[0].numberOfObjects ?? 0
    }




    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell

        else { let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        cell.selectionStyle = .none

        let postCoreData = self.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.object(at: indexPath)

        cell.setupCell(post: postCoreData, coreDataCoordinator: coreDataCoordinator, profileVC: nil, savedPostsVC: self)

        return cell
        
    }



    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action = UIContextualAction(style: .destructive, title: NSLocalizedString("tableViewAction", tableName: "SavedPostsViewControllerLocalizable", comment: "Удалить из сохраненного") ) { [weak self] (uiContextualAction, uiView, completionHandler) in


            let post = self?.coreDataCoordinator.fetchedResultsControllerSavePostCoreData?.object(at: indexPath)

            if let post {

                post.favourite = nil

                self?.coreDataCoordinator.savePersistentContainerContext()

                self?.tableView.reloadData()

                completionHandler(true)
            }
        }


        let actionConfiguration = UISwipeActionsConfiguration(actions: [action])
        actionConfiguration.performsFirstActionWithFullSwipe = true

        return actionConfiguration
    }
}






extension SavedPostsViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {


        switch type {

        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            self.tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        @unknown default:
            self.tableView.reloadData()
        }
    }

}
