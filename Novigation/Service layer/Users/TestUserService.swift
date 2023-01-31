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


    private func saveProfile(values: [String: String]) {

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

                let currentUser: User = User(currentProfile.name ?? "",
                                             userStatus: currentProfile.status ?? "",
                                             userImage: UIImage(named: "avatar")! )

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
                        print("🤸🏼‍♂️ user is cached")


                        getProfileByEmail()

                        // CoreDadaUser подгружаем по логину из CoreData


//                        let currentUser: User = User("Cashed AleksandrSiberia",
//                                                     userStatus: "Test",
//                                                     userImage: UIImage(named: "avatar")! )
//
//                        completion(currentUser)
                    }




                    else {
                        print("📩 save new user" )

                        let values = ["email": login, "name": "AleksandrSiberia test1", "status": "test"]
                        self.saveProfile(values: values)

                        getProfileByEmail()

                    }
                }

            }




            else {

                print("📩 save new user, 0 cashed users" )

                let values = ["email": login, "name": "AleksandrSiberia test1", "status": "test"]
                self.saveProfile(values: values)

                getProfileByEmail()




                // пишем в CoreDate и сразу грузим

//                let currentUser: User = User("New Zero AleksandrSiberia",
//                                             userStatus: "Test",
//                                             userImage: UIImage(named: "avatar")! )
//                completion(currentUser)
            }
        }







    }

}

