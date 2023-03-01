//
//  CoreDataCoordinatorDummy.swift
//  NovigationTests
//
//  Created by Александр Хмыров on 20.12.2022.
//

import Foundation
import CoreData




class CoreDataCoordinatorDummy: CoreDataCoordinatorProtocol {
    func getFolderByName(nameFolder: String?) -> FoldersCoreData? {
        return nil
    }

    func getAllFolders() -> [FoldersCoreData]? {
        return nil
    }

    func deleteFolder(folder: FoldersCoreData) {

    }

    
    func getPostsInFetchedResultsController(nameFolder: String?) {

    }

    func performFetchAllPostCoreData() {

    }

    func performFetchSavePostCoreData() {

    }

    func appendFolder(name: String?) {

    }

    func appendPost(values: [String : Any], currentProfile: ProfileCoreData?, folderName: String?, completion: (String?) -> Void) {

    }

    func appendProfile(values: [String : String]) {

    }

    func getCurrentProfile(completionHandler: @escaping (ProfileCoreData?) -> Void) {

    }

    func deleteCurrentProfile(completionHandler: @escaping (String?) -> Void) {

    }

    func getProfiles(completionHandler: @escaping ([ProfileCoreData]?) -> Void) {

    }

    func appendNewCommentInPost(for post: PostCoreData?, text: String?) {

    }

    func getSavedPost() -> [PostCoreData]? {
        return nil
    }

    func appendDefaultPostsFromCoreData(currentProfile: ProfileCoreData?) {

    }

    func setupFetchedResultsControllerPostCoreData() -> NSFetchedResultsController<PostCoreData>? {
        return nil
    }

    var fetchedResultsControllerSavePostCoreData: NSFetchedResultsController<PostCoreData>?

    var fetchedResultsControllerPostCoreData: NSFetchedResultsController<PostCoreData>?



    func getPosts(nameFolder: String) {}

    func performFetchPostCoreData() {}

    func savePersistentContainerContext() {}

    func appendFolder(name: String) {}



    func deletePost(post: PostCoreData) {}

    func appendPost(author: String?, image: String?, likes: String?, text: String?, views: String?, folderName: String, nameForUrlFoto: String?, completion: (String?) -> Void) {}

    }





