//
//  AppRouter.swift
//  Celeritas_Test
//
//  Created by Muhamad Farooq on 3/30/24.
//

import Foundation
import SwiftUI
import UIKit

/// App class for navigation.
class AppRouter {
    static var shared = AppRouter()
    private init() {}
    
    enum Navigation {
        case push
        case present
        case modal
        case modalFromBottom
    }
    enum BackNavigation {
        case dismiss
        case pop
        case popAll
    }
    /// Static function which cast class into object type from storyboard
    /// i.e let vc:SomeClassController = AppRouter.instantiateViewController(storyboard: .stordyboardname)
    /// This will cast vc automatically to SomeClassController
    ///
    /// - Parameters:
    ///   - storyboard: storyboard from listed storyboards
    ///   - bundle: can be nil which change to default automatically.
    /// - Returns: Intialized object of class.
    static func instantiateViewController<controller: UIViewController>(storyboard: UIStoryboard.Storyboard, bundle: Bundle? = nil ) -> controller {
        
        guard let viewController = UIStoryboard(name: storyboard.filename, bundle: bundle).instantiateViewController(withIdentifier: controller.identifier) as? controller else {
            fatalError("Couldn't instantiate view controller with identifier \(controller.identifier) ")
        }
        
        return viewController
    }
    
    func setNavigationController(_ navigationController: UINavigationController) {
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        navigationController.isNavigationBarHidden = true
        
    }
    
    /// Static function which cast class into object of UINib
    /// i.e let vc:SomeClassController = AppRouter.instantiateViewControllerFromNib()
    /// This will cast vc automatically to SomeClassController
    ///
    /// - Parameter bundle: can be nil which change to default automatically.
    /// - Returns: Intialized object of class.
    static func instantiateViewControllerFromNib<controller: UIViewController>(bundle: Bundle? = nil ) -> controller {
        let viewController = controller(nibName: controller.identifier, bundle: bundle)
        return viewController
    }
    
    ///setting initial root view controller
    static func decideAndMakeRoot(displayVc: UIViewController? = nil) {
        DispatchQueue.main.async {
            Router.configuration = RouterConfiguration.init(baseURL: Enviroment.baseURL, authorizationToken: "")
//            let Vc = UIHostingController(rootView: OnboardView())
            let Vc: CameraViewUIkit = AppRouter.instantiateViewController(storyboard: .home)
            let nvc = UINavigationController(rootViewController: Vc)
            Helper.getInstance.makeSpecificViewRoot(vc: nvc)
            if let displayVc {
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    nvc.pushViewController(displayVc, animated: true)
                }
            }
        }
        
    }
    
    static func logoutPressed() {
        //        decideAndMakeRoot()
        
    }
    static private func showAlert(message: String) {
        
        if let rootWindow = UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController {
            DispatchQueue.main.async {
                rootWindow.showToast(message: message)
            }
            
        }
    }
    
}

// MARK: - Storyboards
extension UIStoryboard {
    
    /// Define everystoryboard name here. start your every storyboard name with capitalized string, otherwise it will crash.
    enum Storyboard : String {
        
        case auth
        case home
        case profile
        case menu
        case ecommerce
        case dashboard
        case main
        /// Capitalize everyStoryboard name.
        var filename : String {
            return rawValue.capitalized
        }
    }
}

extension UIViewController  {
    
    /// Add functionality to every viewController to get string of it's class(viewController) name
    static var identifier: String {
        return String(describing: self)
    }
}

protocol Routeable {
    func route(to vc: AnyView, navigation:AppRouter.Navigation)
    func route(to vc: UIViewController, navigation:AppRouter.Navigation)
    func routeBack(navigation backNavigation:AppRouter.BackNavigation)
}
extension Routeable where Self:UIViewController {
    
    func route(to vc: UIViewController, navigation:AppRouter.Navigation) {
        switch navigation {
        case .push:
            DispatchQueue.main.async {
                if let navigationController = self.navigationController {
                    navigationController.pushViewController(vc, animated: true)
                }else{
                    (UIApplication.shared.topView as? UINavigationController)?.pushViewController(vc, animated: true)
                }
            }
        case .present:
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        case .modal:
            DispatchQueue.main.async {
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
        case .modalFromBottom :
            DispatchQueue.main.async {
                vc.modalPresentationStyle = .overCurrentContext
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func routeBack(navigation backNavigation:AppRouter.BackNavigation) {
        switch backNavigation {
        case .dismiss:
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        case .pop:
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        case .popAll:
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

extension Routeable where Self:View {
    func route(to vc: AnyView, navigation:AppRouter.Navigation) {
        let Vc = UIHostingController(rootView: vc)
        switch navigation {
        case .push:
            DispatchQueue.main.async {
                (UIApplication.shared.topView as? UINavigationController)?.pushViewController(Vc, animated: true)
            }
        case .present:
            DispatchQueue.main.async {
                Vc.modalPresentationStyle = .fullScreen
                UIApplication.shared.topView?.present(Vc, animated: false, completion: nil)
            }
        case .modal:
            DispatchQueue.main.async {
                Vc.modalTransitionStyle = .crossDissolve
                Vc.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.topView?.present(Vc, animated: true, completion: nil)
            }
        case .modalFromBottom :
            DispatchQueue.main.async {
                Vc.modalPresentationStyle = .overCurrentContext
                UIApplication.shared.topView?.present(Vc, animated: true, completion: nil)
            }
        }
    }
    func routeBack(navigation backNavigation:AppRouter.BackNavigation) {
        switch backNavigation {
        case .dismiss:
            DispatchQueue.main.async {
                UIApplication.shared.topView?.dismiss(animated: true, completion: nil)
            }
        case .pop:
            DispatchQueue.main.async {
                UIApplication.shared.topView?.navigationController?.popViewController(animated: true)
            }
        case .popAll:
            DispatchQueue.main.async {
                UIApplication.shared.topView?.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    func route(to vc: UIViewController, navigation: AppRouter.Navigation) { }
}
