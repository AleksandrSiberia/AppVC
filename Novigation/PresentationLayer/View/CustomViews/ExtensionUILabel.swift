//
//  ExtensionUILabel.swift
//  Novigation
//
//  Created by Александр Хмыров on 10.02.2023.
//

import UIKit


extension UILabel {

    static func setupLabelRegular(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }


    static func setupLabelBold(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }
}
