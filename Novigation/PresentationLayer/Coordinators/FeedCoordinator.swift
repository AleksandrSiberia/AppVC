//
//  FeedCoordinator.swift
//  Novigation
//
//  Created by Александр Хмыров on 14.09.2022.
//

import UIKit

class FeedCoordinator: AppCoordinator {



    private weak var transitionHandler: UINavigationController?

    var childs: [AppCoordinator] = []

    init(transitionHandler: UINavigationController) {
        self.transitionHandler = transitionHandler
    }


    func start() -> UINavigationController {
        return showFeedScreen()
    }

    
    fileprivate func showFeedScreen() -> UINavigationController {
        
        let feedScreen = transitionHandler
        feedScreen?.tabBarItem = UITabBarItem(title: "Лента", image: UIImage(systemName: "house"), tag: 1)
        
        return feedScreen ?? UINavigationController()
    }
}



