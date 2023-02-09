//
//  File.swift
//  Novigation
//
//  Created by Александр Хмыров on 21.12.2022.
//

import Foundation


protocol ProfileViewControllable {

    var currentProfile: ProfileCoreData? { get set }
    var coreDataCoordinator: CoreDataCoordinatorProtocol! { get set }
}
