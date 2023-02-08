//
//  TestUserService.swift
//  Novigation
//
//  Created by Александр Хмыров on 29.08.2022.
//

import UIKit
import RealmSwift
import CoreData


class TestUserService: UserServiceProtocol {





    var coreDataCoordinator: CoreDataCoordinatorProtocol?

    init(coreDataCoordinator: CoreDataCoordinatorProtocol?) {
        self.coreDataCoordinator = coreDataCoordinator
    }
  
}
