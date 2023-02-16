//
//  CoreDataCoordinatorProtocol.swift
//  Novigation
//
//  Created by Александр Хмыров on 20.12.2022.
//

import Foundation
import CoreData


protocol CoreDataCoordinatorProtocol {

    
    var fetchedResultsControllerPostCoreData: NSFetchedResultsController<PostCoreData>? { get set }

    var fetchedResultsControllerSavePostCoreData: NSFetchedResultsController<PostCoreData>? { get set }

    func getPosts(nameFolder: String?)

    func performFetchAllPostCoreData()

    func performFetchSavePostCoreData()

    func savePersistentContainerContext()

    func appendFolder(name: String?)

    func appendPost(values: [String: Any], folderName: String?, completion: (String?) -> Void)

    func getFolderByName(nameFolder: String?) -> FoldersCoreData?

    func getAllFolders() -> [FoldersCoreData]?

    func deleteFolder(folder: FoldersCoreData)

    func deletePost(post: PostCoreData)

    func appendProfile(values: [String: String])

    func getCurrentProfile(completionHandler: @escaping (ProfileCoreData?) -> Void)

    func deleteCurrentProfile(completionHandler: @escaping (_ success: String?) -> Void)

    func getProfiles(completionHandler: @escaping ([ProfileCoreData]?) -> Void )

    func appendNewCommentInPost(for post: PostCoreData?, values: [String: Any] )
}










