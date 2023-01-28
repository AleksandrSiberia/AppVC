//
//  FileManagerServable.swift
//  Novigation
//
//  Created by Александр Хмыров on 13.01.2023.
//

import Foundation
import UIKit



protocol FileManagerServiceable {

    func saveImage(imageData: UIImage?, completionHandler: @escaping ((Bool, urlNewFile: String, String)?) -> Void)
}
