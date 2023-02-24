//
//  UserService.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.09.2022.
//

import Foundation
import UIKit
import KeychainSwift



protocol UserServiceProtocol {

    var coreDataCoordinator: CoreDataCoordinatorProtocol? { get set }

    func getUserByEmail(email: String, completionHandler: @escaping (ProfileCoreData) -> Void )

    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (ProfileCoreData?) -> Void )
}



extension UserServiceProtocol {

    private func saveDefaultProfile(login: String) {

        let values = ["email": login,
                      "name": "Aleksandr",
                      "status": "учусь...",
                      "avatar": "avatar",
                      "surname": "Khmyrov",
                      "gender": "man",
                      "birthday": "02.03.2022",
                      "hometown": "Иркутск",
                      "education": "ИГУ Высшее юридическое, нутрицсолог, фитнесс инструктор",
                      "career": "Автор уникальной системы тренировок и книги BOOKFINESS",
                      "interest": "Фитнесс, путешествия",
                      "mobilePhone": "8(999)111-11-11",
        ]

        coreDataCoordinator?.appendProfile(values: values)
    }



    func getUserByEmail(email: String, completionHandler: @escaping (ProfileCoreData) -> Void ) {

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
            completionHandler(currentProfile)
        }
    }



    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (ProfileCoreData?) -> Void ) {

        loginInspector.checkCredentials(withEmail: login, password: password) {string in

            guard string == "Открыть доступ" else {
                print("‼️ в доступе отказано")
                completion(nil)
                return
            }


            if UserDefaults.standard.string(forKey: login) == "ThisUserSavedInCoreData" {
                /// cached user

                self.getUserByEmail(email: login) { currentUser in

                    completion(currentUser)
                }
            }


            else {
                /// save new user
                self.saveDefaultProfile(login: login)

                self.getUserByEmail(email: login) { currentUser in
                    completion(currentUser)
                }
            }
        }
    }
}
