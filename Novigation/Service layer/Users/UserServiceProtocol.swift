//
//  UserService.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.09.2022.
//

import Foundation
import UIKit



protocol UserServiceProtocol {

    var coreDataCoordinator: CoreDataCoordinatorProtocol? { get set }

    func getUserByEmail(email: String, completionHandler: @escaping (User) -> Void )

    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (User?) -> Void )
}




extension UserServiceProtocol {

    private func saveDefaultProfile(login: String) {

        let values = ["email": login,
                      "name": "Aleksandr",
                      "status": "Test",
                      "avatar": "avatar",
                      "surname": "Khmyrov",
                      "gender": "man",
                      "birthday": "02.03.2012",
                      "hometown": "Иркутск",
                      "education": "ИГУ Высшее юридическое",
                      "career": "",
                      "interest": "Фитнесс, путешествия"

        ]

        coreDataCoordinator?.appendProfile(values: values)
    }


    func getUserByEmail(email: String, completionHandler: @escaping (User) -> Void ) {

        self.coreDataCoordinator?.getProfiles { profileCoreData in

            guard let profileCoreData = profileCoreData  else {
                print("‼️ self.coreDataCoordinator?.getProfiles == nil")
                return
            }

            let currentsProfile = profileCoreData.filter { $0.email == email}

            guard currentsProfile.isEmpty == false else {
                print("‼️ currentProfile.isEmpty == true")
                return}

            guard let currentProfile = currentsProfile.first else {
                print("‼️ currentProfile == nil")
                return
            }

            let avatar = UIImage(named: currentProfile.avatar ?? "")

            let fullName = (currentProfile.name ?? "") + " " + (currentProfile.surname ?? "")

            let currentUser: User = User(fullName,
                                         userStatus: currentProfile.status ?? "",
                                         userImage: avatar!)

            completionHandler(currentUser)
        }
    }



    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (User?) -> Void ) {

        loginInspector.checkCredentials(withEmail: login, password: password) {string in

            guard string == "Открыть доступ" else {
                completion(nil)
                return
            }


            if RealmService.shared.getAllUsers()?.isEmpty == false {

                for user in RealmService.shared.getAllUsers() ?? [] {

                    if login == user.login {

                        print("🤸🏼‍♂️ this is cached user")

                        self.getUserByEmail(email: login) { currentUser in

                            completion(currentUser)
                        }
                    }



                    else {
                        print("📩 save new user" )

                        self.saveDefaultProfile(login: login)

                        self.getUserByEmail(email: login) { currentUser in
                            completion(currentUser)
                        }
                    }
                }
            }


            else {

                print("📩 save new user, 0 cashed users" )

                self.saveDefaultProfile(login: login)

                self.getUserByEmail(email: login) { currentUser in
                    completion(currentUser)
                }
            }
        }

    }

}
