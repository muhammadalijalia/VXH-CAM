//
//  Helper.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation
import UIKit

open class Helper{
static public let getInstance = Helper()
private init(){}

public var controlTintColor : UIColor = .black
var isShown = false
static var unnAuthShown = false


/// SETTING NAVIGATION WITH OPTIONS
///
/// - Parameters:
///   - leftBarItem: LEFT BAR ITEM TO SET
///   - rightBarItem: RIGHT BAR ITEM TO SET
///   - title: TITLE OF NAV BAR
///   - isTransparent: IS NAV BAR TRANSPARENT 'DEFAULT = FALSE'
///   - isBottomLine: IS BOTTOM BLACK LINE ON NAVIGATION REQUIRED 'DEFAULT = FALSE'
///   - titleView: CUSTOM VIEW ON TITLE IF ANY
///   - itemsColor: COLORS OF BAR ITEMS SUCH AS 'TITLE, BARITEMS'
///   - titleFontStyle: TITLE FONT STYLE
///   - itemsFontStyle: ITEMS FONT STYLE
///   - titlesFontSize: FONT SIZE OF TITLE
///   - itemsFontSize: FONT SIZE OF ITEMS
///   - vc: INSTANCE OF VIEWCONTROLLER WHERE NAVIGATION EXISTS
public func setNavigationBar(leftBarItem: UIBarButtonItem?=nil,
                              rightBarItem: UIBarButtonItem?=nil,
                             rightBarItems: [UIBarButtonItem]?=nil,
                              title: String,
                              isTransparent: Bool=false,
                              isBottomLine: Bool=false,
                              titleView: UIView?=nil,
                              backgroundColor: UIColor=UIColor.white,
                              itemsColor: UIColor=UIColor.black,
                              titleFontStyle: UIFont?=nil,
                              itemsFontStyle: UIFont?=nil,
                              titlesFontSize: CGFloat=17,
                              itemsFontSize: CGFloat=17,
                              vc: UIViewController){
    
    var font = UIFont.systemFont(ofSize: 17)
    if titleFontStyle != nil{
        font = titleFontStyle!
    }
    
    var itemsFont = UIFont.systemFont(ofSize: 17)
    if itemsFontStyle != nil{
        itemsFont = itemsFontStyle!
    }
    
    if(rightBarItem != nil){
        rightBarItem?.setTitleTextAttributes([NSAttributedString.Key.font : itemsFont], for: .normal)
        vc.navigationItem.rightBarButtonItem = rightBarItem
    }
    if(rightBarItems != nil){
        rightBarItem?.setTitleTextAttributes([NSAttributedString.Key.font : itemsFont], for: .normal)
        vc.navigationItem.rightBarButtonItems = rightBarItems
    }
    
    if(leftBarItem != nil){
        leftBarItem?.setTitleTextAttributes([NSAttributedString.Key.font : itemsFont], for: .normal)
        vc.navigationItem.leftBarButtonItem = leftBarItem
    }
    
    if (titleView == nil){
        vc.navigationItem.title = title
    }else{
        vc.navigationItem.titleView = titleView!
    }
    
    if !isTransparent{

        vc.navigationController?.navigationBar.barTintColor = backgroundColor
        vc.navigationController?.navigationBar.backgroundColor = backgroundColor
        if !isBottomLine{
            vc.navigationController?.navigationBar.shadowImage = UIImage()
        }else{
            vc.navigationController?.navigationBar.shadowImage = UIColor(red: 214/255, green: 214/255, blue: 214/255, alpha: 1.0).as1ptImage()
        }
    }else{
        vc.navigationController?.navigationBar.barTintColor = UIColor.clear//color
        vc.navigationController?.navigationBar.backgroundColor = UIColor.clear//.getDarkBlueColor//color
        vc.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        vc.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    vc.navigationController?.navigationBar.tintColor = itemsColor
    
    vc.navigationItem.backBarButtonItem?.tintColor = itemsColor
    
    vc.navigationItem.rightBarButtonItem?.tintColor = itemsColor
    vc.navigationItem.leftBarButtonItem?.tintColor = itemsColor
    vc.navigationItem.setHidesBackButton(true, animated: false)
    
    
    let titleDict: NSDictionary = [NSAttributedString.Key.foregroundColor : itemsColor,
                                   NSAttributedString.Key.font : font]
    vc.navigationController?.navigationBar.titleTextAttributes = titleDict as? [NSAttributedString.Key : Any]
    
}


///set specific view controller as root
    public func makeSpecificViewRoot(vc: UIViewController){
        var snapshot: UIView?
        var rootVC: UIViewController?

        rootVC = vc
        DispatchQueue.main.async {
            snapshot = (UIApplication.shared.windows.first(where: \.isKeyWindow)?.snapshotView(afterScreenUpdates: true))
            if let snapshot, let rootVC {
                rootVC.view.addSubview(snapshot);
                UIApplication.shared.windows.first(where: \.isKeyWindow)?.rootViewController = rootVC;
                UIView.transition(with: snapshot, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    snapshot.layer.opacity = 0;
                }, completion: { (status) in
                    snapshot.removeFromSuperview()
                })
            } else {
                print("🔥 No snapshot found")
            }
        }
}
/// THIS WILL SHOW ALERT CONTROLLER
///
/// - Parameters:
///   - title: TITLE OF ALERT
///   - message: DESCRIPTION OF ALERT
///   - actions: ACTIONS TO SHOW
///   - defaultActionTitle: DEFAULT ACTION TITLE
///   - isDefaultActionReq: IS DEFAULT ACTION VISIBLE OR NOT
///   - vc: PRESENT FROM WHICH VIEW CONTROLLER
public func showAlert(title : String ,
                      message : String,
                      actions: [UIAlertAction]?=nil,
                      defaultActionTitle: String?="Ok",
                      isDefaultActionReq: Bool?=true,
                      vc: UIViewController?=nil){
    guard !isShown else { return }
    isShown = !isShown
    let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)
    if actions != nil {
        for action in actions!{
            alertController.addAction(action)
        }
    }
    if isDefaultActionReq!{
        _ = UIAlertAction(title: defaultActionTitle, style: .default, handler: nil)
//        alertController.addAction(alertAction)
    }
    DispatchQueue.main.async {
        if let rootWindow = UIApplication.getTopViewController(){
            rootWindow.present(alertController, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
                    rootWindow.presentedViewController?.dismiss(animated: true)
                    isShown = !isShown
                }
            }
        }
    }
}
    


///set nav bar clear color
public func setNavBarClearColor(vc: UIViewController){
    vc.navigationController?.navigationBar.barTintColor = UIColor.clear//color
    vc.navigationController?.navigationBar.backgroundColor = UIColor.clear//.getDarkBlueColor//color
}

///add underline to attributed string
public func addUnderLine(attStr: NSMutableAttributedString,
                         range: NSRange,
                         url : URL!) -> NSMutableAttributedString{
    attStr.addAttribute(NSAttributedString.Key.link, value: url!, range: range)
    attStr.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: 1), range: range)
    attStr.addAttribute(NSAttributedString.Key.underlineColor, value: UIColor.black, range: range)
    return attStr
}

///add shadow at bottom
public func showShadowAtBottom(view: UIView){
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 50)
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 1.0
}

///present view controller with model presentation style
public func presentModally(vc: UIViewController,
                           fromVC : UIViewController){
    vc.providesPresentationContextTransitionStyle = true
    vc.definesPresentationContext = true
    vc.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    DispatchQueue.main.async {
        fromVC.present(vc, animated: true, completion: nil)
    }
}

///present view controller with model presentation style
public func presentModallyOnRoot(vc: UIViewController){
    vc.providesPresentationContextTransitionStyle = true
    vc.definesPresentationContext = true
    vc.modalPresentationStyle=UIModalPresentationStyle.overCurrentContext
    vc.modalTransitionStyle = .crossDissolve
    DispatchQueue.main.async {
        if let rootWindow = UIApplication.getTopViewController(){
            rootWindow.present(vc, animated: true, completion: nil)
        }
    }
}

///create center label
public func createCenterLblForTitle(titleTxt: NSString) -> UILabel{
    let label = UILabel(frame: CGRect(x:0, y:0, width:100, height:40))
    label.backgroundColor = .clear
    label.numberOfLines = 2
    label.textAlignment = .center
    label.textColor = UIColor.black
    label.center = CGPoint(x: 22, y: UIScreen.main.bounds.width / 2)
    
    //getting the range to separate the button title strings
    let newlineRange: NSRange = titleTxt.range(of: "\n")
    
    //getting both substrings
    var substring1: NSString = ""
    var substring2: NSString = ""
    
    if(newlineRange.location != NSNotFound) {
        substring1 = titleTxt.substring(to: newlineRange.location) as NSString
        substring2 = titleTxt.substring(from: newlineRange.location) as NSString
    }
    
    //assigning diffrent fonts to both substrings
    let font:UIFont? = UIFont.boldSystemFont(ofSize: 14)
    let attrString =  NSMutableAttributedString(string: substring1 as String, attributes: [NSAttributedString.Key.font: font!])
    
    let font1:UIFont? = UIFont.systemFont(ofSize: 11)
    let attrString1 =  NSMutableAttributedString(string: substring2 as String, attributes: [NSAttributedString.Key.font: font1!])
    
    //appending both attributed strings
    attrString.append(attrString1)
    
    //assigning the resultant attributed strings to the button
    label.attributedText = attrString
    return label
}

///check if any field is empty or not
public func checkWeatherTextFieldEmpty(textFieldWithErrorMsg: [UITextField: String]) -> String{
    for (textField, msg) in textFieldWithErrorMsg{
        if textField.text == ""{
            return msg
        }
    }
    return ""
}

///make call
public func makeCall(number: String){
    if let url = URL(string: "tel://\(number)"), UIApplication.shared.canOpenURL(url) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}


///get string presentation of integer value
public func getStringOfInteger(value: Double) -> String{
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = .spellOut
    return numberFormatter.string(from: NSNumber(value: value)) ?? ""
}



///round off to point .2f
public func roundOfPoint25Of(num: Double) -> Double{
    
    let floorInt : Int = Int(floor(num))
    var afterDecimalFinal = 0.0
    let remainderDecimal = num.truncatingRemainder(dividingBy: 1)
    let twoDigitsDecimal : Double = Double(String(format: "%.2f", arguments: [remainderDecimal]))!
    
    if twoDigitsDecimal != 0.00{
        if twoDigitsDecimal <= 0.25{
            afterDecimalFinal = 0.25
        }else if twoDigitsDecimal <= 0.50{
            afterDecimalFinal = 0.50
        }else if twoDigitsDecimal <= 0.75{
            afterDecimalFinal = 0.75
        }else if twoDigitsDecimal > 0.75{
            afterDecimalFinal = 1.0
        }
    }
    let returnDouble : Double = Double(Double(floorInt) + afterDecimalFinal)
    return returnDouble
    
}

///make glow on view
public func makeGlowOnView(view: UIView){
    let color = UIColor.red
    view.layer.shadowColor = color.cgColor
    view.layer.shadowRadius = 4.0
    view.layer.shadowOpacity = 0.9
    view.layer.shadowOffset = CGSize.zero
    view.layer.masksToBounds = false
}

///remove flow on view
public func removeGlowFromView(view: UIView){
    let color = UIColor.clear
    view.layer.shadowColor = color.cgColor
    view.layer.shadowRadius = 0.0
    view.layer.shadowOpacity = 0.0
    view.layer.shadowOffset = CGSize.zero
    view.layer.masksToBounds = true
}

///show location disable alert
public func showLocationSettingsAlert(isCancelBtnRequired: Bool=true){
    let appDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    let alert = UIAlertController(title: "Alert", message: "\"\(appDisplayName)\" Detect that your application's location setting is disable, Please enable location service for better results.", preferredStyle: .alert)
    let action = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
        Helper.getInstance.openAppSettings()
        alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    if isCancelBtnRequired{
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(cancelAction)
    }
    DispatchQueue.main.async{
        if let rootWindow = UIApplication.getTopViewController(){
            rootWindow.present(alert, animated: true, completion: nil)
        }
    }
}

///show contact disable alert
public func showContactSettingsAlert(){
    let appDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String ?? ""
    let alert = UIAlertController(title: "Alert", message: "\"\(appDisplayName)\" Detect that your application's contact permission is disable. Kindly enable permission to find your friends.", preferredStyle: .alert)
    let cancelaction = UIAlertAction(title: "Cancel", style: .default) { (action) in
        alert.dismiss(animated: true, completion: nil)
    }
    let action = UIAlertAction(title: "Go to Settings", style: .default) { (action) in
        Helper.getInstance.openAppSettings()
        alert.dismiss(animated: true, completion: nil)
    }
    alert.addAction(action)
    alert.addAction(cancelaction)
    DispatchQueue.main.async{
        if let rootWindow = UIApplication.getTopViewController(){
            rootWindow.present(alert, animated: true, completion: nil)
        }
    }
}


///open application settings
public func openAppSettings(){
    DispatchQueue.main.async {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
                UIApplication.shared.openURL(settingsUrl as URL)
            }
        }
    }
}

///convert string to dictionary
public func convertToDictionary(text: String) -> [String: Any]? {
    if let data = text.data(using: .utf8) {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            print(error.localizedDescription)
        }
    }
    return nil
}

//Email Validation
public func isValidEmail(testStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: testStr)
}

//Password Validation
public func isValidPassword(testStr:String) -> Bool {
    let passRegEx = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[-_!?/<>;:{}()*@#$%^&+=])(?=\\S+$).{4,}$"
    
    let passTest = NSPredicate(format:"SELF MATCHES %@", passRegEx)
    return passTest.evaluate(with: testStr)
}

public func getPercentageFromCountString(resultCount: Int, totalCount: Int) -> String{
    if (Double(Double(resultCount)/Double(totalCount)) * 100) == 0.0{
        return "0%"
    }
    if String(format: "%.1f", Double(Double(resultCount)/Double(totalCount)) * 100).contains(".0") {
        return String(format: "%.0f", Double(Double(resultCount)/Double(totalCount)) * 100) + "%"
    }else{
        return String(format: "%.1f", Double(Double(resultCount)/Double(totalCount)) * 100) + "%"
    }
}

public func getPercentageFromCount(resultCount: Int, totalCount: Int) -> Double{
    return Double(Double(resultCount)/Double(totalCount)) * 100
}

public func setRememberMeIDPass(idStr: String, passStr: String){
    UserDefaults.standard.setValue(idStr, forKey: "RememberID")
    UserDefaults.standard.setValue(passStr, forKey: "RememberPass")
}

public func removeRememberMeIDPass(){
    UserDefaults.standard.setValue("", forKey: "RememberID")
    UserDefaults.standard.setValue("", forKey: "RememberPass")
}

public func getRememberMeIDPass() -> Dictionary<String, String>?{
    var dic : [String: String]? = nil
    if let num = UserDefaults.standard.string(forKey: "RememberID") {
        dic = [:]
        dic!["Id"] = num
        if let pass = UserDefaults.standard.string(forKey: "RememberPass") {
            dic!["pass"] = pass
            return dic!
        }
    }
    return nil
}
}
