//
//  CommentTableViewCellProtocol.swift
//  Novigation
//
//  Created by Александр Хмыров on 23.02.2023.
//

import Foundation
import UIKit


protocol CommentTableViewCellProtocol { }


extension CommentTableViewCellProtocol {

    func setupViewAuthorAvatar() -> UIImageView {

        let imageViewAuthorAvatar = UIImageView()
        imageViewAuthorAvatar.translatesAutoresizingMaskIntoConstraints = false
        imageViewAuthorAvatar.layer.cornerRadius = 15
        imageViewAuthorAvatar.clipsToBounds = true

        return imageViewAuthorAvatar
    }


    func setupImageViewAuthorAvatar(coreData: CoreDataCoordinatorProtocol?, currentPost: PostCoreData?, completionHandler: @escaping (UIImage?) -> Void ) {

        coreData?.getCurrentProfile(completionHandler: { profile in

            guard let profile =  currentPost?.relationshipProfile

            else {
                print("‼️ currentPost?.relationFolder?.allObjects -> nil || isEmpty ")
                return completionHandler(nil)
            }
            return completionHandler(UIImage(named: profile.avatar ?? ""))
        })
    }
}
