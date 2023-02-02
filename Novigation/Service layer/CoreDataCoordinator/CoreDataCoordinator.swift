//
//  CoreDataCoordinator.swift
//  Novigation
//
//  Created by Александр Хмыров on 01.11.2022.
//

import Foundation
import CoreData
import KeychainSwift




final class CoreDataCoordinator: CoreDataCoordinatorProtocol {




    private lazy var persistentContainer: NSPersistentContainer = {


        var persistentContainer = NSPersistentContainer(name: "CoreDadaModel")

        persistentContainer.loadPersistentStores { nsPersistentStoreDescription, error in

            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        return persistentContainer
    }()




   lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()





    lazy var fetchedResultsControllerPostCoreData: NSFetchedResultsController<PostCoreData>? = {

        let request = PostCoreData.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "author", ascending: true)]

        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchResultController
    }()



    lazy var fetchedResultsControllerSavePostCoreData: NSFetchedResultsController<PostCoreData>? = {

        let request = PostCoreData.fetchRequest()

        request.sortDescriptors = [ NSSortDescriptor(key: "author", ascending: true) ]

        let folder = self.getFolderByName(nameFolder: "SavedPosts")


        request.predicate = NSPredicate(format: "relationFolder contains %@", folder!)


        let fetchedResultsControllerSavePostCoreData = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsControllerSavePostCoreData
    }()



    init() {

        if self.getFolderByName(nameFolder: "SavedPosts") == nil {
                    self.appendFolder(name: "SavedPosts")
                }

        if self.getFolderByName(nameFolder: "AllPosts") == nil {
                    self.appendFolder(name: "AllPosts")
                }
    }



    func getPosts(nameFolder: String) {

        guard let folder = getFolderByName(nameFolder: nameFolder) else {
            print(" ‼️ getFolderByName(nameFolder: \(nameFolder) == nil " )
            return}

        
        self.fetchedResultsControllerPostCoreData?.fetchRequest.predicate = NSPredicate(format: "relationFolder contains %@", folder)

        self.performFetchPostCoreData()
    }



    func performFetchPostCoreData() {

        do {
            try self.fetchedResultsControllerPostCoreData?.performFetch()

        }
        catch {
            print("‼️", error.localizedDescription)
        }


        do {
            try self.fetchedResultsControllerSavePostCoreData?.performFetch()
        }

        catch {
            print("‼️", error.localizedDescription)
        }
    }




    func savePersistentContainerContext() {

        if self.backgroundContext.hasChanges {

            do {

                try self.backgroundContext.save()
            }
            catch {
                if let error = error as NSError? {
                    print("Error backgroundContext.save = \(error), \(error.userInfo)")
                }
            }
        }
    }




    func appendFolder(name: String) {

        let folder = FoldersCoreData(context: self.backgroundContext
        )
        folder.name = name
        self.savePersistentContainerContext()

    }



    func appendPost(author: String?, image: String?, likes: String?, text: String?, views: String?, folderName: String, nameForUrlFoto: String?, completion: (String?) -> Void) {


        for postInCoreData in (self.fetchedResultsControllerSavePostCoreData?.sections![0].objects) as! [PostCoreData] {

            if postInCoreData.text == text {
                completion(NSLocalizedString("appendPost", tableName: "ProfileViewControllerLocalizable", comment: "This post has already been saved"))
                return
            }
        }


        let post = PostCoreData(context: self.backgroundContext)
        post.author = author
        post.image = image
        post.text = text
        post.likes = likes
        post.views = views
        post.urlFoto = nameForUrlFoto

        let folder = self.getFolderByName(nameFolder: folderName)

        post.addToRelationFolder(folder!)

        self.savePersistentContainerContext()
        self.performFetchPostCoreData()
    }



    func appendProfile(values: [String: String]) {



        if getFolderByName(nameFolder: "FolderProfile") != nil {

            append(values: values)
        }


        else {
            appendFolder(name: "FolderProfile")

            append(values: values)
        }



        func append(values: [String: String]) {

            guard let folder = getFolderByName(nameFolder: "FolderProfile") else {
                print(" ‼️ getFolderByName(nameFolder: FolderProfile) == nil " )
                return}

            let newProfile = ProfileCoreData(context: self.backgroundContext)

            newProfile.relationFolder = folder

            newProfile.email = values["email"]
            newProfile.name = values["name"]
            newProfile.surname = values["surname"]
            newProfile.status = values["status"]
            newProfile.avatar = values["avatar"]

            savePersistentContainerContext()
        }
    }


    
    func getCurrentProfile(completionHandler: @escaping (ProfileCoreData?) -> Void) {

        guard let emailCurrentUser = KeychainSwift().get("userOnline") else {
            print("‼️ KeychainSwift().get(userOnline) == nil")
            return
        }

        getProfiles(completionHandler: { profiles in

            let profiles = profiles?.filter { $0.email == emailCurrentUser }

            guard let profiles, profiles.isEmpty == false else {
                print("‼️ no profiles ")
                return
            }

            if let profile = profiles.first {
                return completionHandler(profile)
            }

            else {

                return  completionHandler(nil)
            }



        })
    }


    func getFolderByName(nameFolder: String) -> FoldersCoreData? {

        let request = FoldersCoreData.fetchRequest()

        request.predicate = NSPredicate(format: "name == %@", nameFolder)

        do {
            let folders = try self.backgroundContext.fetch(request) as NSArray


            if folders.count >= 1 {

                let folder = (folders.filter { ($0 as AnyObject).name == nameFolder }).first

                return folder as? FoldersCoreData
            }
            else {
                return nil
            }
        }
        catch {
            print("‼️", error.localizedDescription)
            return nil
        }
    }




    func getAllFolders() -> [FoldersCoreData]? {

        let request = FoldersCoreData.fetchRequest()

        do {
            return try self.backgroundContext.fetch(request)
        }
        catch {
            print("‼️", error.localizedDescription)
            return nil
        }
    }



    func getProfiles(completionHandler: @escaping ([ProfileCoreData]?) -> Void ) {

        guard let folder = getFolderByName(nameFolder: "FolderProfile") else {
            print(" ‼️ getFolderByName(nameFolder: FolderProfile) == nil " )
            return completionHandler(nil)
        }

        let request = ProfileCoreData.fetchRequest()

        request.predicate = NSPredicate(format: "relationFolder == %@", folder)

        do {
            let profiles = try self.backgroundContext.fetch(request)

            DispatchQueue.main.async {
                 return completionHandler(profiles)
            }
        }
        catch {
            print("‼️", error.localizedDescription)
            return completionHandler(nil)
        }
    }



    func deleteFolder(folder: FoldersCoreData) {

        self.backgroundContext.delete(folder)
        self.savePersistentContainerContext()
    }



    func deletePost(post: PostCoreData) {

        self.backgroundContext.delete(post)
        self.savePersistentContainerContext()
        self.performFetchPostCoreData()
    }



    func deleteCurrentProfile(completionHandler: @escaping (_ success: String?) -> Void) {

        getCurrentProfile { currentProfile in

            if let currentProfile {
                self.backgroundContext.delete(currentProfile)
                self.savePersistentContainerContext()
                completionHandler("current profile deleted")
            }
        }
    }



}


