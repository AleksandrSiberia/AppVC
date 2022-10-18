//
//  TestUserService.swift
//  Novigation
//
//  Created by Александр Хмыров on 29.08.2022.
//

import UIKit

class TestUserService: UserServiceProtocol {


    private var currentUser: User = User("Test AleksandrSiberia",
                                         
                                         userStatus: "Test",
                                         userImage: UIImage(named: "avatar")! )

    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (User?) -> Void ) {

        loginInspector.checkCredentials(withEmail: login, password: password) {string in

            guard string == "Открыть доступ" else {
                completion(nil)
                return
            }
            completion(self.currentUser)
        }
    }

}

