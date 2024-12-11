//
//  Loader.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation

import UIKit
import DGActivityIndicatorView


open class Loader {
    private init(){setUIComponents()}
    
    private static let instance = Loader()
    
    static public func getInstance() -> Loader{
        return instance
    }
    
    private var activityIndicatorView : DGActivityIndicatorView!
    private var viewForActivity = UIView()
    private var TxtLbl = UILabel()
    private var timer = Timer()
    
    
    public var loaderColor: UIColor = .white
    public var backColor: UIColor = UIColor.black.withAlphaComponent(0.4)
    public var textColor: UIColor = .white
    public var loaderType : DGActivityIndicatorAnimationType = .ballSpinFadeLoader
    public var loaderSize : CGFloat = 50.0
    
    private func setUpLoader(backColor: UIColor?=nil,
                             loaderColor: UIColor?=nil,
                             txtToShow: String?=nil,
                             txtColor: UIColor?=nil,
                             loaderType : DGActivityIndicatorAnimationType?=nil){
        
        if var rootVC = UIApplication.getTopViewController(){
            if rootVC.isKind(of: UINavigationController.self){
                if let scrollView = (rootVC as? UINavigationController)?.topViewController?.isKind(of: UITableViewController.self){
                    rootVC = (rootVC as! UINavigationController)
                }else{
                    rootVC = (rootVC as! UINavigationController).topViewController!
                }
            }
            self.viewForActivity.isHidden = false
            self.activityIndicatorView.isHidden = false
            self.viewForActivity.backgroundColor = (backColor != nil) ? backColor : self.backColor
            if txtToShow != nil{
                self.TxtLbl.isHidden = false
            }
            
            if loaderColor == nil{
                self.activityIndicatorView.tintColor = self.loaderColor
            }else{
                self.activityIndicatorView.tintColor = loaderColor!
            }
            
            if loaderType == nil{
                self.activityIndicatorView.type = self.loaderType
            }else{
                self.activityIndicatorView.type = loaderType!
            }
            
            UIView.animate(withDuration: 0.2) {
                self.viewForActivity.alpha = 1.0
                self.activityIndicatorView.alpha = 1.0
                if txtToShow != nil{
                    self.TxtLbl.alpha = 1.0
                }
            }
            if txtToShow != nil{
                self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeUpdate), userInfo: nil, repeats: true)
                self.viewForActivity.addSubview(self.TxtLbl)
            }
            self.viewForActivity.frame = rootVC.view.bounds
            self.activityIndicatorView.center = self.viewForActivity.center
            self.viewForActivity.addSubview(self.activityIndicatorView)
            
            if txtToShow != nil{
                self.TxtLbl.frame = CGRect(x: 20, y: self.activityIndicatorView.frame.maxY + 10, width: rootVC.view.bounds.width - 40, height: 50)
                self.TxtLbl.text = txtToShow!
                self.TxtLbl.textAlignment = .center
                if txtColor == nil{
                    self.TxtLbl.textColor = self.textColor
                }else{
                    self.TxtLbl.textColor = txtColor!
                }
            }
            DispatchQueue.main.async {
                rootVC.view.addSubview(self.viewForActivity)
                rootVC.view.bringSubviewToFront(self.viewForActivity)
            }
        }
        
    }
    
    public func showLoader(backColor: UIColor?=nil,
                           loaderColor: UIColor?=nil,
                           txtToShow: String?=nil,
                           txtColor: UIColor?=nil,
                           loaderType : DGActivityIndicatorAnimationType?=nil){
        DispatchQueue.main.async {
            self.setUpLoader(backColor: backColor,
                        loaderColor: loaderColor,
                        txtToShow: txtToShow,
                        txtColor: txtColor,
                        loaderType: loaderType)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func setUIComponents(){
        self.activityIndicatorView = DGActivityIndicatorView(type: .ballSpinFadeLoader, tintColor: self.loaderColor, size: 50)
        self.activityIndicatorView.bounds = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        self.TxtLbl.bounds = CGRect(x: 0.0, y: 0.0, width: 50.0, height: 50.0)
        viewForActivity.backgroundColor = self.backColor
        TxtLbl.backgroundColor = UIColor.clear
        self.viewForActivity.alpha = 0
        self.TxtLbl.alpha = 0
    }
    
    public func hideLoader(){
        DispatchQueue.main.async {
            if self.activityIndicatorView != nil{
                self.activityIndicatorView.stopAnimating()
                self.timer.invalidate()
                if let rootVC = UIApplication.getTopViewController(){
                    if(rootVC.view.subviews.contains(self.viewForActivity)){
                        UIView.animate(withDuration: 0.2, animations: {
                            self.viewForActivity.alpha = 0.0
                            self.activityIndicatorView.alpha = 0.0
                            self.TxtLbl.alpha = 0.0
                        }, completion: { (status) in
                            if status {
                                self.hideAndRemoveFromSuperView()
                            }
                        })
                    }else{
                        self.hideAndRemoveFromSuperView()
                    }
                }else{
                    self.hideAndRemoveFromSuperView()
                }
            }
        }
    }
    
    func hideAndRemoveFromSuperView(){
        self.timer.invalidate()
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = true
            self.viewForActivity.isHidden = true
            self.TxtLbl.isHidden = true
            self.TxtLbl.removeFromSuperview()
            self.activityIndicatorView.removeFromSuperview()
            self.viewForActivity.removeFromSuperview()
        }
    }
    
    @objc func timeUpdate(){
        DispatchQueue.main.async {
            if !self.TxtLbl.isHidden && self.TxtLbl.text != nil{
                if self.TxtLbl.text!.contains("..."){
                    self.TxtLbl.text = self.TxtLbl.text!.components(separatedBy: "...").first!
                }else if self.TxtLbl.text!.contains(".."){
                    self.TxtLbl.text = self.TxtLbl.text! + "."
                }else if self.TxtLbl.text!.contains("."){
                    self.TxtLbl.text = self.TxtLbl.text! + "."
                }else{
                    self.TxtLbl.text = self.TxtLbl.text! + "."
                }
            }else{
                self.timer.invalidate()
            }
        }
    }
}
