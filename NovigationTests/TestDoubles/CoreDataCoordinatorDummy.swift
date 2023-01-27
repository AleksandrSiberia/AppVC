//
//  CoreDataCoordinatorDummy.swift
//  NovigationTests
//
//  Created by Александр Хмыров on 20.12.2022.
//

import Foundation
import CoreData




class CoreDataCoordinatorDummy: CoreDataCoordinatorProtocol {
    var fetchedResultsControllerSavePostCoreData: NSFetchedResultsController<PostCoreData>?

    var fetchedResultsControllerPostCoreData: NSFetchedResultsController<PostCoreData>?



    func getPosts(nameFolder: String) {}

    func performFetchPostCoreData() {}

    func savePersistentContainerContext() {}

    func appendFolder(name: String) {}

    func getFolderByName(nameFolder: String) -> FoldersPostCoreData? { return nil }

    func getAllFolders() -> [FoldersPostCoreData]? { return nil }

    func deleteFolder(folder: FoldersPostCoreData) {}

    func deletePost(post: PostCoreData) {}

    func appendPost(author: String?, image: String?, likes: String?, text: String?, views: String?, folderName: String, nameForUrlFoto: String?, completion: (String?) -> Void) {}

    }





