//
//  TestUserService.swift
//  Novigation
//
//  Created by Александр Хмыров on 29.08.2022.
//

import UIKit
import RealmSwift

class TestUserService: UserServiceProtocol {


    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (User?) -> Void ) {


        loginInspector.checkCredentials(withEmail: login, password: password) {string in

            guard string == "Открыть доступ" else {
                completion(nil)
                return
            }


            if RealmService.shared.getAllUsers()?.isEmpty == false {

                for user in RealmService.shared.getAllUsers() ?? [] {

                    if login == user.login {
                        print("🤸🏼‍♂️ user is cached")

                        // CoreDadaUser подгружаем по логину из CoreData

                        let currentUser: User = User("Cashed AleksandrSiberia",
                                                     userStatus: "Test",
                                                     userImage: UIImage(named: "avatar")! )
                        completion(currentUser)
                    }




                    else {
                        print("📩 save new user" )

                        // пишем в CoreDate и сразу грузим

                        let currentUser: User = User("New AleksandrSiberia",
                                                     userStatus: "Test",
                                                     userImage: UIImage(named: "avatar")! )

                        completion(currentUser)
                    }
                }

            }




            else {

                print("📩 save new user, 0 cashed users" )

                // пишем в CoreDate и сразу грузим

                let currentUser: User = User("New Zero AleksandrSiberia",
                                             userStatus: "Test",
                                             userImage: UIImage(named: "avatar")! )
                completion(currentUser)
            }
        }







    }

}

