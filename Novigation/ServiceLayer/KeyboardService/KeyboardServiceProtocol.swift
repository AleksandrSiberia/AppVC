//
//  KeyboardService.swift
//  Novigation
//
//  Created by Александр Хмыров on 28.02.2023.
//

import Foundation
import UIKit


protocol KeyboardServiceProtocol {
    
    func keyboardWillShow<T,D>(notifications: Notification, view: UIView, viewScroll: T, bottomElement: D, correction: CGFloat?) where T: UIScrollView, D: UIView
    
}



extension KeyboardServiceProtocol {
    
    func keyboardWillShow<T,D>(notifications: Notification, view: UIView, viewScroll: T, bottomElement: D, correction: CGFloat?) where T: UIScrollView, D: UIView {
        
        guard let keyboardHeight = (notifications.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height, let screenHeight = view.window?.frame.height
        else { print("‼️ UIResponder.keyboardFrameEndUserInfoKey && view.window?.frame.height == nil")
            return }
        
        
        let viewHeight = view.frame.height
        
        let navigationBarHeight = screenHeight - viewHeight
        
        let scrollViewElementsMaxY = bottomElement.frame.maxY + navigationBarHeight
        
        let keyboardMinY = viewHeight - keyboardHeight
        
        if scrollViewElementsMaxY > keyboardMinY {
            
            let contentOffset = scrollViewElementsMaxY - keyboardMinY
            
            viewScroll.contentOffset.y = contentOffset + 15 + (correction ?? 0)
        }
    }
}
