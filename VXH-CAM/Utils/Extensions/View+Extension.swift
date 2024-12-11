//
//  View+Extension.swift
//  VXH-CAM
//
//  Created by Admin on 4/12/24.
//

import Foundation
import SwiftUI

extension View {
    func showToast(message: String, duration: Double? = nil, completion: (() -> Void)? = nil)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
            UIApplication.shared.topView?.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + (duration ?? 1.5)
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: completion)
            }
        }
    }
  
}

extension View {
    
    /// THIS FUNCTION WILL SET STATUS BAR BACKGROUND COLOR
    ///
    /// - Parameter color: STATUS BAR BACKGROUND COLOR
    public func setStatusBarColor(color: UIColor?=UIColor.clear){
        let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
    
    ///return back bar button which are using in whole app
    public func backBarButton(image: UIImage) -> UIBarButtonItem {
        self.swipeToPopEnable()
        let backButtonItem = UIBarButtonItem(image: image,
                                             style: .plain,
                                             target: self,
                                             action: #selector(UIApplication.shared.topView?.BackButtonTapped))
        return backButtonItem
    }
    
    
    
    /// THIS FUNCTION WILL REMOVE DEFAULT BACK GESTURE
    public func swipeToPopDisable() {
        
        UIApplication.shared.topView?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        UIApplication.shared.topView?.navigationController?.interactivePopGestureRecognizer?.delegate = self as? any UIGestureRecognizerDelegate
    }
    
    /// THIS GESTURE WILL ENABLE / ADD DEFAULT BACK GESTURE
    public func swipeToPopEnable() {
        UIApplication.shared.topView?.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        UIApplication.shared.topView?.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    
    /// GESTURE RECOGNIZER DELEGATE
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == UIApplication.shared.topView?.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
    
}
