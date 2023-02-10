//
//  CustomLabel.swift
//  Novigation
//
//  Created by Александр Хмыров on 06.02.2023.
//

import Foundation
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


extension UIImageView {

    static func setupImageView(systemName: String) -> UIImageView {

        let image = UIImage(systemName: systemName )?.withRenderingMode(.alwaysTemplate)
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        imageView.tintColor = .systemGray

        return imageView
    }

}


final class CustomViews {

    private init() {
    }



    static func setupTextView(text: String?) -> UITextView  {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }

    static func setupTextField(text: String?, keyboardType: UIKeyboardType) -> UITextField {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.text = text
        textField.backgroundColor = .systemGray6
        textField.layer.cornerRadius = 12
        textField.keyboardType = keyboardType
        return textField
    }


}

