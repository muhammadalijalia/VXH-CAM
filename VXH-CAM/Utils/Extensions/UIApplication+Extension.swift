//
//  UIApplication+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation
import UIKit


extension UIApplication {
    
    var topWindow: UIWindow   {
        return UIApplication.shared.windows.filter({$0.isKeyWindow}).first ?? UIWindow()
    }
    
    var statusBarHeight : CGFloat {
        return (UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? UIViewController)?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height  ?? 0
    }
    
    var KeyWindow: UIWindow? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
            .map { $0.windows.first { $0.isKeyWindow } ?? UIWindow() }
    }
    
    
    var topView : UIViewController? {
        if let Vc = topWindow.rootViewController {
            return Vc
        }
        return nil
    }
    var topPresnetedView : UIViewController? {
        if let Vc = topWindow.rootViewController?.presentedViewController {
            return Vc
        }
        return nil
    }
    class func getTopViewController(base: UIViewController? = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController) -> UIViewController? {

        if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}
