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
import KeychainSwift




final class ProfileViewController: UIViewController, UIGestureRecognizerDelegate, ProfileViewControllable, ProfileViewControllerDelegate, ViewControllersDelegate {

    private var arrayCells: [PostCell] = []

    var currentProfile: ProfileCoreData? {

        willSet {
            tableView.reloadData()
        }
    }

    
    lazy var userService: UserServiceProtocol = {
#if DEBUG
        return TestUserService(coreDataCoordinator: coreDataCoordinator)
#else
        return CurrentUserService(coreDataCoordinator: coreDataCoordinator)
#endif
    }()

    
    var coreDataCoordinator: CoreDataCoordinatorProtocol?

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


    private lazy var tapGestureRecogniser: UITapGestureRecognizer = {
        var tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(self.actionTapGestureRecogniser(recogniser:)))
        tapGestureRecogniser.delegate = self
        tapGestureRecogniser.numberOfTapsRequired = 2
        return tapGestureRecogniser
    }()


    private var number = {
        return 3
    }()


    private var posts: [ModelPost] = []

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

        coreDataCoordinator?.getPostsInFetchedResultsController(nameFolder: KeychainSwift().get("userOnline") )

        loadUserFromCoreData()

        coreDataCoordinator?.appendDefaultPostsFromCoreData(currentProfile: currentProfile)


        view.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)

        view.addSubview(tableView)
        view.addGestureRecognizer(tapGestureRecogniser)

        setupConstraints()
    }



    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = true

        if coreDataCoordinator?.fetchedResultsControllerPostCoreData?.delegate == nil {

            coreDataCoordinator?.fetchedResultsControllerPostCoreData?.delegate = self
        }

        reloadTableView()
        
        handle = Auth.auth().addStateDidChangeListener { auth, user in }

        saveNewViewsPost()

    }



    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.output?.timerStop()
        Auth.auth().removeStateDidChangeListener(handle!)
    }




    func loadUserFromCoreData() {

        guard let emailUser = KeychainSwift().get("userOnline") else {
            print("‼️ error: KeychainSwift().get(userOnline) == nil")
            return
        }

        userService.getUserByEmail(email: emailUser) { currentUser  in
            self.currentProfile = currentUser
            self.tableView.reloadData()
        }
    }



    private func saveNewViewsPost() {

        for cell in arrayCells {

            if cell.countViews == nil {
                if let views = cell.currentPost?.views {
                    cell.countViews = true
                    cell.currentPost?.views = views + 1
                    coreDataCoordinator?.savePersistentContainerContext()
                    reloadTableView()
                }
            }
        }
    }




    func showMassage(text: String) {

        let alert = UIAlertController(title: nil, message: text, preferredStyle: .actionSheet)

        present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.dismiss(animated: true)
        }
    }



    func addNewPost() {

        let controller = AddNewPostViewController(coreDataCoordinator: coreDataCoordinator, fileManagerService: fileManager, delegate: self )
        controller.currentProfile = currentProfile

        navigationController?.pushViewController(controller, animated: true)
  //      let nav = UINavigationController(rootViewController: controller)
 //       present(nav, animated: true)
    }



    func showSettingViewController() {
        let settingViewController = SettingViewController(coreData: coreDataCoordinator, delegate: self)
        let nav = UINavigationController(rootViewController: settingViewController)
        present(nav, animated: true)
    }



    func showDetailedInformationsViewController() {
        let detailedInformationViewController = DetailedInformationViewController(currentProfile: currentProfile, coreData: coreDataCoordinator)

        let navDetailedInformationViewController = UINavigationController(rootViewController: detailedInformationViewController)
        present(navDetailedInformationViewController, animated: true)
    }



    func showEditPostTextViewController(currentPost: PostCoreData?)  {
        let controller = EditPostTextViewController(currentPost: currentPost, delegate: self, coreData: coreDataCoordinator)
        let navController = UINavigationController(rootViewController: controller)

        present(navController, animated: true)
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


    func dismissController() {
        dismiss(animated: true)
    }



    private func setupConstraints() {

        let safeAria = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAria.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAria.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAria.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAria.bottomAnchor)
        ])
    }



    @objc private func actionTapGestureRecogniser(recogniser: UITapGestureRecognizer) {

        if recogniser.state == .ended {
            let tapLocation = recogniser.location(in: tableView)
            if let tapIndexPathTableView = tableView.indexPathForRow(at: tapLocation) {
                if let tappedCell = tableView.cellForRow(at: tapIndexPathTableView) as? PostCell {
                    
                    var massage = tappedCell.savePost()

                    if massage == nil {

                        massage = NSLocalizedString("actionTapGestureRecogniser", tableName: "ProfileViewControllerLocalizable", comment: "post saved")
                    }

                    showMassage(text: massage ?? "что-то пошло не так".allLocalizable)
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

            if let section = coreDataCoordinator?.fetchedResultsControllerPostCoreData?.sections, section.isEmpty == false, let array = section.first  {
                return array.numberOfObjects
            }
            return 0
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

            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell
            else { let cell = self.tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }

            cell.selectionStyle = .none

            guard let section = coreDataCoordinator?.fetchedResultsControllerPostCoreData?.sections, section.isEmpty == false, let arrayPosts = section.first, arrayPosts.numberOfObjects - 1 >= indexPath.row, let post = arrayPosts.objects?[indexPath.row] as? PostCoreData
            else { return  self.tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)}

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

            cell.setupCell(post: post, coreDataCoordinator: coreDataCoordinator, delegate: self)

            return cell

        }
    }


    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            guard let profileHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as? ProfileHeaderView else { return nil }

            if currentProfile != nil {
                profileHeaderView.setupHeader(currentProfile!, delegate: self)
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



    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        view.endEditing(true)
        arrayCells.forEach { $0.viewEditPostIsHidden() }
    }
}




extension ProfileViewController: NSFetchedResultsControllerDelegate {

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        self.tableView.reloadData()
    }
}



extension ProfileViewController: UITableViewDragDelegate {

    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let text = (coreDataCoordinator?.fetchedResultsControllerPostCoreData?.sections?[0].objects?[indexPath.row] as? PostCoreData)?.text

        // можно передать NSString
        let textData = NSItemProvider(item: text?.data(using: .utf8) as? NSData,
                                      typeIdentifier: UTType.plainText.identifier)

        let image = UIImage(named: (coreDataCoordinator?.fetchedResultsControllerPostCoreData?.sections?[0].objects?[indexPath.row] as? PostCoreData)?.image ?? "" )

        // можно передавать UIImage
        let imageData = image?.pngData() as? NSData

        let imageItemProvider = NSItemProvider(item: imageData, typeIdentifier: UTType.image.identifier)


        return [
            UIDragItem(itemProvider: textData),
            UIDragItem(itemProvider: imageItemProvider)
        ]
    }
}



extension ProfileViewController: UITableViewDropDelegate {

    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {

        coordinator.session.loadObjects(ofClass: UIImage.self) { array in

            if array.count > 0 {

                let image = array.first as! UIImage

                self.fileManager?.saveImage(imageData: image) {

                    ( tuple: (completion: Bool, urlNewFile: String, nameFoto: String)? ) -> Void   in

                    guard let tuple else {
                        print("‼️ (completion: Bool, urlString: String, nameFoto: String)? == nil")
                        return
                    }

                    let nameFoto =  tuple.2

                    let values: [String: String]  =  ["author": "Drag&Drop",
                                                      "image": "",
                                                      "text": UUID().uuidString,
                                                      "likes": "0",
                                                      "views": "0",
                                                      "nameForUrlFoto": nameFoto ]

                    self.coreDataCoordinator?.appendPost(values: values, currentProfile: self.currentProfile, folderName: "AllPosts") { _ in }


                    self.coreDataCoordinator?.performFetchAllPostCoreData()
                }
            }
        }
    }



    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {

        return session.canLoadObjects(ofClass: UIImage.self) || session.canLoadObjects(ofClass: NSString.self)
    }
}
