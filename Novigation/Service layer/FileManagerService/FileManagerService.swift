//
//  FileManager.swift
//  Novigation
//
//  Created by Александр Хмыров on 13.01.2023.
//

import Foundation
import UIKit



class FileManagerService: FileManagerServiceable {


    private lazy var manager = FileManager.default

    private lazy var documentStringURL = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first

    private lazy var documentURL = self.manager.urls(for: .documentDirectory, in: .userDomainMask).first



    init() {

        print("🎉 url document = \(String(describing: self.documentStringURL))")
    }



    func saveImage(imageData: UIImage?, completionHandler: @escaping ((Bool, String, String)?) -> Void)  {


        guard let url = self.documentStringURL else {
            print("‼️ var documentStringURL = nil")
            return completionHandler(nil)

        }

        guard let imageData else {
            print("‼️ imageData: NSData? = nil")
            return completionHandler(nil)
        }


        let date = Date()

        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yy-MM-dd-HH_mm_ss"

        let stringDateNameFoto = dateFormatter.string(from: date)


        let urlNewFile = url + "/" + stringDateNameFoto


        let conditionCreateFile = manager.createFile(atPath: urlNewFile, contents: imageData.pngData())



        guard conditionCreateFile else {
            print("‼️ conditionCreateFile == nil")
            return completionHandler(nil)
        }


        return  completionHandler((conditionCreateFile, urlNewFile, stringDateNameFoto))

    }
}
