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


    private func saveProfile(login: String) {

        let values = ["email": login, "name": "AleksandrSiberia test1", "status": "test", "avatar": "avatar" ]

        if coreDataCoordinator?.getFolderByName(nameFolder: "FolderProfile") != nil {

            coreDataCoordinator?.appendProfile(values: values)
        }


        else {
            coreDataCoordinator?.appendFolder(name: "FolderProfile")

            coreDataCoordinator?.appendProfile(values: values)
        }

    }



    func checkTheLogin(_ login: String, password: String, loginInspector: LoginViewControllerDelegate, loginViewController: LoginViewController, completion: @escaping (User?) -> Void ) {


        func getProfileByEmail() {

            self.coreDataCoordinator?.getProfiles { profileCoreData in

                guard let profileCoreData = profileCoreData  else {
                    print("‼️ self.coreDataCoordinator?.getProfiles == nil")
                    return
                }

                let currentsProfile = profileCoreData.filter { $0.email == login}

                guard currentsProfile.isEmpty == false else {
                    print("‼️ currentProfile.isEmpty == true")
                    return}

                guard let currentProfile = currentsProfile.first else {
                    print("‼️ currentProfile == nil")
                    return
                }


                let avatar = UIImage(named: currentProfile.avatar ?? "")

                let currentUser: User = User(currentProfile.name ?? "",
                                             userStatus: currentProfile.status ?? "",
                                             userImage: avatar!,
                                            userEmail: login)

                completion(currentUser)

            }

        }



        loginInspector.checkCredentials(withEmail: login, password: password) {string in

            guard string == "Открыть доступ" else {
                completion(nil)
                return
            }


            if RealmService.shared.getAllUsers()?.isEmpty == false {

                for user in RealmService.shared.getAllUsers() ?? [] {

                    if login == user.login {
                        print("🤸🏼‍♂️ this is cached user")

                        getProfileByEmail()

                    }


                    else {
                        print("📩 save new user" )

                        self.saveProfile(login: login)

                        getProfileByEmail()

                    }
                }

            }




            else {

                print("📩 save new user, 0 cashed users" )

                self.saveProfile(login: login)

                getProfileByEmail()
            }
        }







    }

}

