//
//  ProfileViewControllerDelegate.swift
//  Novigation
//
//  Created by Александр Хмыров on 23.02.2023.
//

import Foundation


protocol ProfileViewControllerDelegate {

    func addNewPost()
    func showSettingViewController()
    func loadUserFromCoreData()
    func showDetailedInformationsViewController()
}
