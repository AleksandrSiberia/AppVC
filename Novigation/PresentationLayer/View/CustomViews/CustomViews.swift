//
//  CustomLabel.swift
//  Novigation
//
//  Created by Александр Хмыров on 06.02.2023.
//

import Foundation
import UIKit


class CustomViews {

    static func setupLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }


    static func setupTextView(text: String?) -> UITextView  {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.text = text
        return textView
    }
}
