//
//  LoginCoordinator.swift
//  Novigation
//
//  Created by Александр Хмыров on 14.09.2022.
//

import UIKit

class ProfileCoordinator: AppCoordinatorProtocol {


    var coreDataCoordinator: CoreDataCoordinatorProtocol?

    private weak var transitionHandler: UINavigationController?

    var childs: [AppCoordinatorProtocol] = []

    var profileViewController: ProfileViewControllable?



    init(transitionHandler: UINavigationController?, coreDataCoordinator: CoreDataCoordinatorProtocol, profileViewController: ProfileViewControllable?) {
        self.transitionHandler = transitionHandler
        self.coreDataCoordinator = coreDataCoordinator
        self.profileViewController = profileViewController
    }
    


    func start(user: ProfileCoreData) -> Bool {

        profileViewController?.currentProfile = user
        profileViewController?.coreDataCoordinator = coreDataCoordinator

        transitionHandler?.pushViewController(profileViewController as! UIViewController, animated: true)

        return true
    }
}
