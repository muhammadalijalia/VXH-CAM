//
//  UIView+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
import UIKit

extension UIView {
    static var identifire:String{
        get{return String(describing: Self.self)}
    }
    static var nib :UINib{
        get{
            let bundle = Bundle(for: Self.self)
            return UINib(nibName: identifire, bundle: bundle)
        }
    }
    func addCornerRadius(_ radius: CGFloat) {
          self.layer.cornerRadius = radius
          self.layer.masksToBounds = true // Needed to clip the view to its bounds
      }
    func addTopShadowAndRoundedCorners(shadowColor: UIColor = .black,
                                          shadowOffset: CGSize = CGSize(width: 0, height: -14),
                                          shadowOpacity: Float = 0.5,
                                          shadowRadius: CGFloat = 20,
                                          cornerRadius: CGFloat = 15) {
           
           // Set corner radius for top corners
           let cornerMask: CACornerMask = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
           self.layer.cornerRadius = cornerRadius
           self.layer.maskedCorners = cornerMask

           // Set shadow properties
           self.layer.shadowColor = shadowColor.cgColor
           self.layer.shadowOffset = shadowOffset
           self.layer.shadowOpacity = shadowOpacity
           self.layer.shadowRadius = shadowRadius
           self.layer.masksToBounds = false

           // Shadow path for top shadow only
           let shadowRect = CGRect(x: -shadowRadius,
                                   y: -shadowRadius,
                                   width: bounds.width + shadowRadius * 2,
                                   height: shadowRadius)
           self.layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
       }
    func applyBorderStyle(borderColor: UIColor? = nil, borderWidth: CGFloat? = nil, cornerRadius: CGFloat? = nil, addWhiteBorder: Bool? = true) {
            if let color = borderColor {
                self.layer.borderColor = color.cgColor
            }
            if let width = borderWidth {
                self.layer.borderWidth = width
            }
            if let radius = cornerRadius {
                self.layer.cornerRadius = radius
                self.clipsToBounds = true
            }
        if addWhiteBorder ?? false {
                 let whiteBorderView = UIView()
                 let whiteBorderWidth = 1.5
                 whiteBorderView.translatesAutoresizingMaskIntoConstraints = false
            whiteBorderView.backgroundColor = UIColor.appWhite // Set the background color to white for the border effect
                 whiteBorderView.layer.cornerRadius = (cornerRadius ?? 0) + whiteBorderWidth
                 whiteBorderView.clipsToBounds = true

                 if self.superview != nil {
                     self.superview!.insertSubview(whiteBorderView, belowSubview: self)
                     NSLayoutConstraint.activate([
                         whiteBorderView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -whiteBorderWidth),
                         whiteBorderView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: whiteBorderWidth),
                         whiteBorderView.topAnchor.constraint(equalTo: self.topAnchor, constant: -whiteBorderWidth),
                         whiteBorderView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: whiteBorderWidth)
                     ])
                     whiteBorderView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 2 * whiteBorderWidth).isActive = true
                     whiteBorderView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 2 * whiteBorderWidth).isActive = true
                 }
             }
        }
}
