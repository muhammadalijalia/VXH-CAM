//
//  UIViewCotroller+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation
import UIKit

// MARK: - UIViewController extension
extension UIViewController {
    
    func backBarButton() -> UIBarButtonItem {
        
        self.swipeToPopEnable()
        let backButtonItem = UIBarButtonItem(image: UIImage(named:"back"), style: .plain, target: self, action: #selector(BackButtonTapped))
        return backButtonItem
    }
    
    
    func showToast(message: String, duration: Double? = nil, completion: (() -> Void)? = nil)  {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "", message: message, preferredStyle: .actionSheet)
            self.present(alert, animated: true, completion: nil)
            let when = DispatchTime.now() + (duration ?? 1.5)
            DispatchQueue.main.asyncAfter(deadline: when){
                alert.dismiss(animated: true, completion: completion)
            }
        }
    }
    func applyTransition(to view: UIView?, animation: AnimationType) {
        guard let view = view else { return }
        let transition = CATransition()
        transition.duration = 0.4
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        switch animation {
            case .push:
                transition.type = CATransitionType.push
                transition.subtype = CATransitionSubtype.fromRight
            case .fade:
                transition.type = CATransitionType.fade
        }
        view.layer.add(transition, forKey: nil)
    }
    func shareInfo(description: String,link: String) {
                let activityViewController = UIActivityViewController(activityItems: [description,link], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.topView?.view
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
                if UIDevice.current.userInterfaceIdiom == .pad {
                    activityViewController.popoverPresentationController?.sourceView = UIApplication.shared.windows.first
                    activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 0, width: 500, height: 500)
                    activityViewController.popoverPresentationController?.permittedArrowDirections = [.left]
                    self.present(activityViewController, animated: true, completion: nil)
                }
                else{
                    self.present(activityViewController, animated: true)
                }
            }
    
    func configureRefreshControl(selector: Selector) -> UIRefreshControl {
           let refreshControl = UIRefreshControl()
           refreshControl.backgroundColor = UIColor.clear
           refreshControl.tintColor = UIColor.black
           refreshControl.addTarget(self, action: selector, for: .valueChanged)
           return refreshControl
       }
    
}
extension UIViewController : UIGestureRecognizerDelegate{
    
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
                                             action: #selector(BackButtonTapped))
        return backButtonItem
    }
    
    ///Back Btn Action
    @objc public func BackButtonTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    /// THIS FUNCTION WILL REMOVE DEFAULT BACK GESTURE
    public func swipeToPopDisable() {
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    /// THIS GESTURE WILL ENABLE / ADD DEFAULT BACK GESTURE
    public func swipeToPopEnable() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true;
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
    }
    
    /// GESTURE RECOGNIZER DELEGATE
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            return false
        }
        return true
    }
    
}
