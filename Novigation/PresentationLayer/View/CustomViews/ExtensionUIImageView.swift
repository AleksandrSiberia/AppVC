//
//  ExtensionUIImageView.swift
//  Novigation
//
//  Created by Александр Хмыров on 10.02.2023.
//

import UIKit


extension UIImageView {

    static func setupImageView(systemName: String) -> UIImageView {

        let image = UIImage(systemName: systemName )?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.tintColor = .systemGray

        return imageView
    }
}
