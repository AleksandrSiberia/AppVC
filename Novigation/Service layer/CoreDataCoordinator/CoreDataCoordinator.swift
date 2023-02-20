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

        request.sortDescriptors = [NSSortDescriptor(key: "image", ascending: true)]

        guard let folder = getFolderByName(nameFolder: KeychainSwift().get("userOnline")) else {
            print("getFolderByName(nameFolder: KeychainSwift().get(userOnline) == nil" )
            return nil
        }

        request.predicate = NSPredicate(format: "relationFolder == %@", folder)

        let fetchResultController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchResultController
    }()




    lazy var fetchedResultsControllerSavePostCoreData: NSFetchedResultsController<PostCoreData>? = {

        let request = PostCoreData.fetchRequest()

        request.sortDescriptors = [ NSSortDescriptor(key: "image", ascending: true) ]


        request.predicate = NSPredicate(format: "favourite == %@", "save")

        let fetchedResultsControllerSavePostCoreData = NSFetchedResultsController(fetchRequest: request, managedObjectContext: self.backgroundContext, sectionNameKeyPath: nil, cacheName: nil)

        return fetchedResultsControllerSavePostCoreData
    }()


    func getSavedPost() -> [PostCoreData]? {

        let request = PostCoreData.fetchRequest()

        request.predicate = NSPredicate(format: "favourite == %@", "save")

        do {

            let posts = try backgroundContext.fetch(request)
            return posts
        }

        catch {
            print("‼️", error.localizedDescription)
            return nil
        }

    }


    init() {

        guard let userFolder = KeychainSwift().get("userOnline") else {
            print("‼️ KeychainSwift().get(userOnline) == nil")
            return
        }

        if getFolderByName(nameFolder: userFolder) == nil {
            appendFolder(name: userFolder)
        }
    }



    func getPosts(nameFolder: String?) {

        guard let nameFolder else {
            print("‼️ nameFolder KeyChain == nil")
            return
        }

        guard let folder = getFolderByName(nameFolder: nameFolder) else {
            print(" ‼️ getFolderByName(nameFolder: \(nameFolder) == nil " )
            return}

        self.fetchedResultsControllerPostCoreData?.fetchRequest.predicate = NSPredicate(format: "relationFolder contains %@", folder)

        self.performFetchAllPostCoreData()
    }



    func performFetchAllPostCoreData() {

        do {
            try self.fetchedResultsControllerPostCoreData?.performFetch()

        }
        catch {
            print("‼️", error.localizedDescription)
        }
    }



    func performFetchSavePostCoreData() {

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




    func appendFolder(name: String?) {

        let folder = FoldersCoreData(context: self.backgroundContext
        )
        folder.name = name
        self.savePersistentContainerContext()

    }



    func appendPost(values: [String: Any], currentProfile: ProfileCoreData?, folderName: String?, completion: (String?) -> Void) {


        let post = PostCoreData(context: self.backgroundContext)
        
        post.author = values["author"] as? String
        post.surname = values["surname"] as? String
        post.image = values["image"] as? String
        post.text = values["text"] as? String
        post.likes = values["likes"] as? Int32 ?? 0
        post.views = values["views"] as? Int32 ?? 0
        post.urlFoto = values["nameForUrlFoto"] as? String
        post.likeYou = values["likeYou"] as? Bool ?? false

        guard let folderName else {
            print("‼️ folderName == nil")
            return }

        guard let folder = self.getFolderByName(nameFolder: folderName) else {
            print("‼️ getFolderByName(nameFolder: folderName) == nil")
            return
        }


        post.relationshipProfile = currentProfile

        post.addToRelationFolder(folder)

        self.savePersistentContainerContext()

        self.performFetchAllPostCoreData()
    }




    func appendNewCommentInPost(for post: PostCoreData?, text: String?) {


        getCurrentProfile(completionHandler: { profile in


            guard let post, let profile else {
                print("‼️ appendComment(for post: PostCoreData? == nil || getCurrentProfile == nil")
                return
            }

            let comment = CommentCoreData(context: self.backgroundContext)

            comment.nameAuthor = profile.name
            comment.surnameAuthor = profile.surname
            comment.text = text
            comment.time = Date()

            post.addToRelationshipArrayComments(comment)

            self.savePersistentContainerContext()

        })
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
            newProfile.gender = values["gender"]
            newProfile.birthday = values["birthday"]
            newProfile.hometown = values["hometown"]
            newProfile.education = values["education"]
            newProfile.career = values["career"]
            newProfile.interest = values["interest"]
            newProfile.mobilePhone = values["mobilePhone"]

            savePersistentContainerContext()
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


    func getFolderByName(nameFolder: String?) -> FoldersCoreData? {

        guard let nameFolder else {
            print("‼️ nameFolder == nil ")
            return nil
        }

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



    func deleteFolder(folder: FoldersCoreData) {

        self.backgroundContext.delete(folder)
        self.savePersistentContainerContext()
    }



    func deletePost(post: PostCoreData) {

        self.backgroundContext.delete(post)
        self.savePersistentContainerContext()
        
        self.performFetchAllPostCoreData()
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


