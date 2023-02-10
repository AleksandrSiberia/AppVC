//
//  ExtensionUITextView.swift
//  Novigation
//
//  Created by Александр Хмыров on 10.02.2023.
//

import UIKit


extension UITextView {

    static func setupTextView(text: String?) -> UITextView  {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .systemGray6
        textView.text = text
        textView.font = UIFont.systemFont(ofSize: 14)
        return textView
    }
}
