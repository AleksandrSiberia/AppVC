//
//  Coordinator.swift
//  Novigation
//
//  Created by Александр Хмыров on 13.09.2022.
//

import UIKit

// обертка UITabBarController
class RootCoordinator: AppCoordinatorProtocol {


    private weak var transitionHandler: UITabBarController?

    var childs: [AppCoordinatorProtocol] = []

    var coreDataCoordinator = CoreDataCoordinator()

    var navLoginView: UINavigationController?

    var navSavedPosts: UINavigationController?



    init(transitionHandler : UITabBarController) {
        self.transitionHandler = transitionHandler
    }



    func start() -> UITabBarController? {
        if transitionHandler != nil {
            return showTabBarScreen()!
        }
        return nil
    }



    fileprivate func showTabBarScreen() -> UITabBarController? {

        let feedViewController = FeedAssembly.createFeedViewController()

        feedViewController.coreData = coreDataCoordinator

        let navFeedView = UINavigationController(rootViewController: feedViewController)

        let feedCoordinator = FeedCoordinator(transitionHandler: navFeedView)

        let navLoginView = UINavigationController(rootViewController: LoginAssembly.createLoginViewController(coordinator: self, coreData: self.coreDataCoordinator))


        navLoginView.tabBarItem = UITabBarItem(title: NSLocalizedString("navLoginView", tableName: "TabBarItemLocalizable", comment: "Profile") , image: UIImage(systemName: "person.circle"), tag: 2)
        self.childs.append(feedCoordinator)


        let savedPostsViewController = SavedPostsViewController()
        savedPostsViewController.coreDataCoordinator = self.coreDataCoordinator
        
        let navSavedPosts = UINavigationController(rootViewController: savedPostsViewController)
        self.navSavedPosts = navSavedPosts
        navSavedPosts.tabBarItem = UITabBarItem(title: NSLocalizedString("navSavedPosts", tableName: "TabBarItemLocalizable", comment: "Saved"), image: UIImage(systemName: "heart"), tag: 3)


        self.navLoginView = navLoginView


        transitionHandler!.tabBar.backgroundColor = UIColor.createColorForTheme(lightTheme: .white, darkTheme: .black)
        
        transitionHandler!.viewControllers = [feedCoordinator.start(), navLoginView, navSavedPosts]
        return transitionHandler
    }


    
    func startProfileCoordinator(user: ProfileCoreData) {
        
        let profileCoordinator = ProfileCoordinator(transitionHandler: navLoginView, coreDataCoordinator: coreDataCoordinator, profileViewController: ProfileAssembly.createProfileViewController() as? ProfileViewController)

        profileCoordinator.coreDataCoordinator = coreDataCoordinator
        childs.append(profileCoordinator)

        profileCoordinator.coreDataCoordinator = coreDataCoordinator

        _ = profileCoordinator.start(user: user)
    }
}


