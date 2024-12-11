//
//  UIFont+Extensionn.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation
import UIKit

extension UIFont {
    
    var isBold: Bool {
        return fontDescriptor.symbolicTraits.contains(.traitBold)
    }
    
    var isMedium: Bool {
        if(fontName.contains("Medium")){
            return true
        }else{
            return false
        }
    }
    
    var isRegular: Bool {
        if(fontName.contains("Regular")){
            return true
        }else{
            return false
        }
    }
    var isSemiBold: Bool {
        if(fontName.contains("Semi")){
            return true
        }else{
            return false
        }
    }
    var isThin: Bool {
        if(fontName.contains("Thin")){
            return true
        }else{
            return false
        }
    }
    var pointSizeValue: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? pointSize + 10 : pointSize
    }
}
