//
//  StringExtention.swift
//  Novigation
//
//  Created by Александр Хмыров on 29.01.2023.
//

import Foundation


extension String {

    var allLocalizable: String {

        return NSLocalizedString(self, tableName: "AllLocalizable", comment: "")
    }
}
