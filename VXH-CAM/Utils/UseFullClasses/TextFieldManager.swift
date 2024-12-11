//
//  TextFieldManager.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
import UIKit
open class TextFieldManager : NSObject{
    private override init() {super.init()}
    static public let instance = TextFieldManager()
    
    public var isToolBarRequired = false
    private var textInputViews = [UIResponder]()
    public var tintColor : UIColor = .blue
    public var backgroundColor : UIColor = .gray
    
    private func createToolBar(isFirstField: Bool=false,
                               isLastField: Bool=false) -> UIToolbar{
        let toolBar = UIToolbar.init(frame: CGRect.init(x: 0, y: 0,
                                                        width: UIScreen.main.bounds.width,
                                                        height: 45))
        
        let previousBtn = UIBarButtonItem.init(title: "Previous",
                                               style: UIBarButtonItem.Style.plain,
                                               target: self,
                                               action: #selector(previousBtnTapped))
        
        let spacer = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace,
                                          target: self,
                                          action: nil)
        
        let nextBtn = UIBarButtonItem.init(title: ((isLastField) ? "Done" : "Next"),
                                           style: UIBarButtonItem.Style.plain,
                                           target: self,
                                           action: #selector(nextBtnTapped))
        toolBar.barTintColor = backgroundColor
        previousBtn.tintColor = tintColor
        nextBtn.tintColor = tintColor
        
        if isFirstField {
            toolBar.setItems([spacer,
                              nextBtn], animated: true)
            
        } else {
            toolBar.setItems([previousBtn,
                              spacer,
                              nextBtn], animated: true)
            
        }
        
        return toolBar
    }
    
    /// THIS FUNCTION WILL TAKE INPUT AND SETUP ALL TEXTFIELDS AND TEXTVIEWS.
    ///
    /// - Parameters:
    ///   - textInputViewsArr: ARRAY OF TEXTFIELDS/ TEXTVIEWS.
    ///   - isToolBarRequired: INDICATES IF TOOLBAR IN TOP OF KEYBOARD IS REQUIRED OR NOT.
    public func setupTextFieldsAndTextViews(textInputViewsArr: [UIResponder],
                                          isToolBarRequired: Bool?=nil){
        self.textInputViews = textInputViewsArr
        self.isToolBarRequired = (isToolBarRequired == nil) ? self.isToolBarRequired : isToolBarRequired!
        self.textInputViews.forEach { (field) in
            if field.isKind(of: UITextField.self) || field.isKind(of: UITextView.self){
                
                let isFirstField = (field === self.textInputViews.first) ? true : false
                let isLastField = (field === self.textInputViews.last) ? true : false
                if field.isKind(of: UITextField.self){
                    let txtF = field as! UITextField
                    txtF.addTarget(self, action: #selector(TextFieldsUpdate), for: UIControl.Event.editingDidEndOnExit)
                    if txtF === self.textInputViews.last{
                        txtF.returnKeyType = .done
                    }else{
                        txtF.returnKeyType = .next
                    }
                    if self.isToolBarRequired{
                        txtF.inputAccessoryView = self.createToolBar(isFirstField: isFirstField, isLastField: isLastField)
                    }
                    
                    if !self.isToolBarRequired &&
                        (txtF.keyboardType == .numberPad || txtF.keyboardType == .phonePad || txtF.keyboardType == .numbersAndPunctuation || txtF.keyboardType == .decimalPad){
                        txtF.inputAccessoryView = self.createToolBar(isFirstField: isFirstField, isLastField: isLastField)
                    }
                }else{
                    let txtF = field as! UITextView
                    txtF.inputAccessoryView = self.createToolBar(isFirstField: isFirstField, isLastField: isLastField)
                }
                
            }else{
                fatalError("only textfields and textviews should set")
            }
        }
        
    }
    
    private func convertResponderToTextInput(view: UIResponder) -> UITextInput{
        if view.isKind(of: UITextField.self){
            return view as! UITextField
        }else{
            return view as! UITextView
        }
    }
    
    @objc private func nextBtnTapped(){
        let currFieldIndex =  self.textInputViews.firstIndex { (field) -> Bool in
            return field.isFirstResponder
        }
        if currFieldIndex == nil{
            return
        }
        
        let currField = self.textInputViews[currFieldIndex!]
        if self.textInputViews.count <= currFieldIndex! + 1{
            currField.resignFirstResponder()
            return
        }
        
        self.updateInputView(currFieldIndex!,
                             isNextAction: true)
    }
    
    private func updateInputView(_ currFieldIndex: Int, isNextAction: Bool=true){
        
        var nextORPreviousIndex = currFieldIndex + 1
        if !isNextAction{
            nextORPreviousIndex = currFieldIndex - 1
        }
        
        var secondNextORPreviousIndex = currFieldIndex + 2
        if !isNextAction{
            secondNextORPreviousIndex = currFieldIndex - 2
        }
        var isNextORPreviousInputViewAvailable = false
        
        if (self.textInputViews[nextORPreviousIndex].isKind(of: UITextField.self)){
            let nextField : UITextField = self.convertResponderToTextInput(view: self.textInputViews[nextORPreviousIndex]) as! UITextField
            if nextField.isUserInteractionEnabled && nextField.isEnabled{
                nextField.becomeFirstResponder()
            }else{
                if self.textInputViews.count <= secondNextORPreviousIndex{
                    return
                }
                isNextORPreviousInputViewAvailable = true
            }
        }else{
            let nextField : UITextView = self.textInputViews[nextORPreviousIndex] as! UITextView
            if nextField.isUserInteractionEnabled {
                nextField.becomeFirstResponder()
            }else{
                if self.textInputViews.count <= secondNextORPreviousIndex{
                    return
                }
                isNextORPreviousInputViewAvailable = true
            }
        }
        
        if isNextORPreviousInputViewAvailable{
            isNextORPreviousInputViewAvailable = !isNextORPreviousInputViewAvailable
            if let newNextField = self.textInputViews[secondNextORPreviousIndex] as? UITextField{
                if newNextField.isUserInteractionEnabled && newNextField.isEnabled{
                    newNextField.becomeFirstResponder()
                }
            }else if let newNextField = self.textInputViews[secondNextORPreviousIndex] as? UITextView{
                if newNextField.isUserInteractionEnabled {
                    newNextField.becomeFirstResponder()
                }
            }
        }
    }
    
    @objc private func previousBtnTapped(){
        let currFieldIndex =  self.textInputViews.firstIndex { (field) -> Bool in
            return field.isFirstResponder
        }
        if currFieldIndex == nil{
            return
        }
        
        let currField = self.textInputViews[currFieldIndex!]
        if self.textInputViews.count <= currFieldIndex! - 1{
            currField.resignFirstResponder()
            return
        }
        self.updateInputView(currFieldIndex!,
                             isNextAction: false)
    }
    
    @objc private func TextFieldsUpdate(){
        self.nextBtnTapped()
    }
}


extension UITextField{
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        print("TxtF Frames : \(self.frame)")
        
        return super.becomeFirstResponder()
    }
}
