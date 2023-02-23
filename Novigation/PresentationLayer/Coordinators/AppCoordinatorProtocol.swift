//
//  AppCoordinator.swift
//  Novigation
//
//  Created by Александр Хмыров on 13.09.2022.
//

import Foundation


protocol AppCoordinatorProtocol {

    var childs: [AppCoordinatorProtocol] { get set }
 
}
