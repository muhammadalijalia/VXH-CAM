//
//  NetworkChangeClass.swift
//  PetPlanner
//
//  Created by Muhamad Farooq on 8/5/19.
//  Copyright © 2019 XD. All rights reserved.
//

import Foundation
import Reachability
import UIKit

protocol NetworkChangeNotifiable {
    func setupNetworkChange()
    func unsetNetworkChange()
    func showHideOnNetworkCall(error: Error?)
    var isNetworkAvailable : Bool {get}
}

class NetworkChangeClass: NetworkChangeNotifiable {
    
    private var topView: UIButton!
    private var isVisible: Bool = false
    
    var isNetworkAvailable: Bool {
        try! reachability = Reachability()
        return reachability.connection != .unavailable
    }
    var reachability : Reachability!
    
    func setupNetworkChange() {
        
        try! reachability = Reachability()
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
            } else {
                print("Reachable via Cellular")
            }
            self.hidePopup()
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            self.showPopup()
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Reachability error")
        }
    }
    
    func unsetNetworkChange() {
        reachability.stopNotifier()
        hidePopup()
    }
    /// fucntion manages popup
    func showPopup() {
        if self.topView == nil {
            self.setupView()
        } else {
            self.showView()
        }
    }
    
    /// Private Function with custom properties to setup display popup
    private func setupView() {
        let bounds = UIScreen.main.bounds
        let height: CGFloat = 40
        topView = UIButton(frame: CGRect(x: 20, y: bounds.height + 50, width: (bounds.width - 40), height: height))
        topView.setTitleColor(UIColor.black, for: .normal)
        
        topView.contentHorizontalAlignment = .center
        topView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        //        self.topView.layer.shadowColor = Theme.aquaColorDark.cgColor
        self.topView.layer.cornerRadius = 8.0
        self.topView.layer.shadowOffset = CGSize(width: 1, height: 1)
        self.topView.layer.shadowOpacity = 1.0
        self.topView.layer.shadowRadius = 3.0
        self.topView.addTarget(self, action: #selector(offlineTapped(_:)), for: .touchUpInside)
        let window = UIApplication.shared.windows.filter({$0.isKeyWindow})
        if window.count != 0 {
            window.first?.addSubview(self.topView)
        }
        
        self.showView()
    }
    
    /// Private function to display when internet is not connected
    private func showView() {
        guard !isVisible else {
            return
        }
        topView.setTitle("You're offline, Please tap to retry.", for: .normal)
        //        topView.backgroundColor = Theme.aquaColorDark
        isVisible = true
        
        UIView.animate(withDuration: 1.0) {
            self.topView.frame.origin.y = UIScreen.main.bounds.height - CGFloat(50.0)
        }
    }
    
    /// Private function to hide with animation when internet is connected
    func hidePopup() {
        guard self.topView != nil else {
            return
        }
        guard isVisible else {
            return
        }
        topView.setTitle("Back Online", for: .normal)
        //        topView.backgroundColor = Theme.aquaColorDark
        isVisible = false
        
        UIView.animate(withDuration: 1.5) {
            
            self.topView.frame.origin.y = UIScreen.main.bounds.height + CGFloat(50.0)
        }
    }
    
    /// Selector: Method to recheck internet connectivity by hitting a sample request
    ///
    /// - Parameter sender: sender description
    @objc func offlineTapped(_ sender: UIButton){
        
        try! reachability = Reachability()
        
        guard reachability.connection != .unavailable else {
            return
        }
        Router.APIRouter(completeURL: "https://www.google.com", endPoint: nil, parameters: nil, method: .get) { response in
            
        }
    }
    
    func showHideOnNetworkCall(error: Error?){
        if error?._code == NSURLErrorNotConnectedToInternet
            || error?._code == NSURLErrorNetworkConnectionLost
            || error?._code == NSURLErrorCannotConnectToHost
            || error?._code == NSURLErrorCannotFindHost
            || error?._code == NSURLErrorTimedOut {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showPopup()
            }
            return
        }
        DispatchQueue.main.async {
            self.hidePopup()
        }
    }
}
