//
//  ExtensionUITextField.swift
//  Novigation
//
//  Created by Александр Хмыров on 10.02.2023.
//

import UIKit


extension UITextField {

    static func setupTextField(text: String?, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.keyboardType = keyboardType
        return textField
    }

    static func setupTextFieldComment(text: String?, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.keyboardType = keyboardType
        textField.placeholder = "Напишите коментарий"
        return textField
    }
}
