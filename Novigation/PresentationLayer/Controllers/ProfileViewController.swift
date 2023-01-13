//
//  ProfileViewController.swift
//  Novigation
//
//  Created by Александр Хмыров on 26.05.2022.
//

import UIKit
import iOSIntPackage
import FirebaseAuth
import CoreData
import UniformTypeIdentifiers



protocol ProfileViewControllerOutput {
    func timerStop()
}



final class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, ProfileViewControllable {

    var coreDataCoordinator: CoreDataCoordinatorProtocol!

    var fileManager: FileManagerServiceable?

    var handle: AuthStateDidChangeListenerHandle?


    var delegate: ProfileViewDelegate! {

        didSet {

            self.delegate.didChange = { [ unowned self ] delegate in
                
                if delegate.posts != nil {
                    self.posts = delegate.posts!
                    self.tableView.reloadData()
                }
            }
        }
    }

    var output: ProfileViewControllerOutput?

    private var posts: [ModelPost] = []

    var currentUser: User?



    private lazy var tapGestureRecogniser: UITapGestureRecognizer = {
        var tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.actionTapGestureRecogniser(recogniser:)))
        tapGestureRecogniser.delegate = self
        tapGestureRecogniser.numberOfTapsRequired = 2
        return tapGestureRecogniser
    }()



    private lazy var tableView: UITableView = {
        var tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.dragDelegate = self
        tableView.dropDelegate = self

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        tableView.register(PostCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosTableViewCell")

#if DEBUG
        tableView.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
#else
        tableView.backgroundColor =  UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

#endif

        return tableView
    }()




    override func viewDidLoad() {
        super.viewDidLoad()


        self.view.addSubview(self.tableView)
        self.view.addGestureRecognizer(self.tapGestureRecogniser)
        self.setupConstraints()
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

        self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.delegate = self

        
        if self.delegate != nil {
            self.delegate.showPost()
        }
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            // ...
        }


        self.coreDataCoordinator.getPosts(nameFolder: "AllPosts")

        if (self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.sections?.first?.objects?.isEmpty)! {
            for post in arrayModelPost {
                self.coreDataCoordinator.appendPost(author: post.author, image: post.image, likes: String(post.likes), text: post.description, views: String(post.views), folderName: "AllPosts", urlFoto: nil) { _ in
                }
            }
        }

        //      self.tableView.reloadData()
    }




    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)


        self.output?.timerStop()
        Auth.auth().removeStateDidChangeListener(handle!)
    }



    private func setupConstraints() {
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }

    


    @objc private func actionTapGestureRecogniser(recogniser: UITapGestureRecognizer) {

        if recogniser.state == .ended {
            let tapLocation = recogniser.location(in: self.tableView)
            if let tapIndexPathTableView = self.tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = self.tableView.cellForRow(at: tapIndexPathTableView) as? PostCell {

                    var error = tappedCell.savePost()

                    if error == nil {
                        error = NSLocalizedString("actionTapGestureRecogniser", tableName: "ProfileViewControllerLocalizable", comment: "post saved")
                    }

                    let alert = UIAlertController(title: error, message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .cancel)
                    alert.addAction(action)

                    self.present(alert, animated: true)
                }

            }
        }
    }
}





extension ProfileViewController: UITableViewDelegate, UITableViewDataSource  {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        }
        if section == 1 {
            return self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.sections?[0].numberOfObjects ?? 0
        }
        else {
            return 0
        }
    }




    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PhotosTableViewCell", for: indexPath) as? PhotosTableViewCell else { let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            cell.selectionStyle = .none
            self.output = cell
            return cell
        }

        else {
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else { let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }

            cell.selectionStyle = .none

            if let posts = self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.sections?.first?.objects as? [PostCoreData] {

                if posts.count >= indexPath.row + 1 {

                    let post = posts[indexPath.row ]

                    cell.setup(author: post.author, image: post.image, likes: post.likes, text: post.text, views: post.views, urlFoto: post.urlFoto, coreDataCoordinator: self.coreDataCoordinator)
                    return cell
                }
                else {
                    return cell
                }
            }
            else {
                return cell
            }
        }
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            guard let profileHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as? ProfileHeaderView else { return nil }
            if currentUser != nil {
                profileHeaderView.setupUser(currentUser!)
            }
            return profileHeaderView
        }
        return nil
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.section == 0 && indexPath.row == 0 {

            self.navigationController?.pushViewController(PhotosAssembly.showPhotosViewController(), animated: true)
        }
    }
}





extension ProfileViewController: NSFetchedResultsControllerDelegate {


    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        self.tableView.reloadData()
    }
}



extension ProfileViewController: UITableViewDragDelegate {


    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let text = (self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.sections?[0].objects?[indexPath.row] as? PostCoreData)?.text

        let textData = NSItemProvider(item: text?.data(using: .utf8) as? NSData,
                                      typeIdentifier: UTType.plainText.identifier)

        let image = UIImage(named: (self.coreDataCoordinator.fetchedResultsControllerPostCoreData?.sections?[0].objects?[indexPath.row] as? PostCoreData)?.image ?? "" )

        let imageData = image?.pngData() as? NSData

        let imageItemProvider = NSItemProvider(item: imageData, typeIdentifier: UTType.image.identifier)


        return [UIDragItem(itemProvider: textData), UIDragItem(itemProvider: imageItemProvider)]
    }
}



extension ProfileViewController: UITableViewDropDelegate {


    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        _ = coordinator.session.loadObjects(ofClass: UIImage.self) { array in

            if array.count > 0 {

                let image = array.first as! UIImage

                self.fileManager?.saveImage(imageData: image) {

                    ( tuple: (completion: Bool, urlString: String, nameFoto: String)? ) -> Void   in

                    guard let tuple else {
                        print("‼️ (completion: Bool, urlString: String, nameFoto: String)? == nil")
                        return
                    }

                    let urlFoto = "file://" + tuple.1
                 //   let nameFoto = tuple.2

                    print("🎀", urlFoto)

                    self.coreDataCoordinator.appendPost(author: "Drag&Drop", image: nil, likes: "0", text: "Drag&Drop", views: "0", folderName: "AllPosts", urlFoto: urlFoto) { _ in }

                    self.coreDataCoordinator.performFetchPostCoreData()


                }

                print("🌹", image)

            }
        }
    }
}
