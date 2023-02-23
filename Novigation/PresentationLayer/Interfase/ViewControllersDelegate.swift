//
//  ViewControllersDelegate.swift
//  Novigation
//
//  Created by Александр Хмыров on 22.02.2023.
//

import Foundation


protocol ViewControllersDelegate {

    func showMassage(text: String)

    func showEditPostTextViewController(currentPost: PostCoreData?)
    func dismissController()
    func reloadTableView()
    func beginUpdatesTableView()
    func endUpdatesTableView()

}
