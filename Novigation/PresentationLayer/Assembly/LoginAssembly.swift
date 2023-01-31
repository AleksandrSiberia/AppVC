//
//  LoginAssembly.swift
//  Novigation
//
//  Created by Александр Хмыров on 14.09.2022.
//

import Foundation



final class LoginAssembly {

    static func createLoginViewController(coordinator: RootCoordinator, coreData: CoreDataCoordinatorProtocol) -> LoginViewController {


        let view = LoginViewController()
        let viewModel = LoginViewModel(coordinator: coordinator)
        let loginInspector = MyLoginFactory().makeLoginInspector()
        let checkPassword = CheckerPassword()
        checkPassword.view = view

        view.loginDelegate = loginInspector
        view.outputCheckPassword = checkPassword
        view.corseDataCoordinator = coreData

        view.output = viewModel

        return  view
    }
}
