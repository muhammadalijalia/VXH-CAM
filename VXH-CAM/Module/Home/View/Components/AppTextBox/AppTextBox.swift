//
//  AppTextBox.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import UIKit

class AppTextBox: UIView, NibFileOwnerLoadable {
    
    // Outlets and Variables
    var view: UIView!
    
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak private var errorLbl: UILabel!
    @IBOutlet weak var lblTop: UILabel!
    @IBOutlet weak var btnShowPass: UIButton!
    
    var isFilled: Bool {
        get {
            
            if textField.text! == "" {
                errorLbl.isHidden = false
                errorLbl.text = "Required"
                return false
                
            } else {
                errorLbl.isHidden = true
                return true
            }
        }
    }
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        self.textField.autocorrectionType = .no
    }
    
    func xibSetup() {
        
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        
        self.errorLbl.isHidden = true
        self.errorLbl.numberOfLines = 0
        self.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.textField.addTarget(self, action: #selector(textFieldDidEnd(_:)), for: .editingDidEnd)
        self.mainView.layer.borderWidth = 1
        self.mainView.layer.borderColor = UIColor.appBlue.cgColor
        self.mainView.layer.cornerRadius = 4
        addSubview(view)
        
        self.setFont()
        self.viewModel.delegate = self
    }
    
    @objc func textFieldDidEnd(_ textField: UITextField) {
        
        let _ = viewModel.validate()
        
    }
    private func setFieldType() {
        
        self.textField.autocorrectionType = .no
        switch viewModel.fieldValidation {
        case .email, .iban:
            self.btnShowPass.isHidden = true
            self.textField.keyboardType = .emailAddress
            textField.autocapitalizationType = .none
        case .password, .normal_password, .matchPass:
            self.btnShowPass.isHidden = false
            self.textField.isSecureTextEntry = true
            textField.autocapitalizationType = .none
        case .phone:
            self.btnShowPass.isHidden = true
            self.textField.keyboardType = .phonePad
        case .general, .none, .name:
            self.btnShowPass.isHidden = true
            self.textField.autocapitalizationType = .words
            
        case .emailOrNumber:
            break
        }
    }
    
    func setFont(placeholder: String = "",
                 placeHolderColor: UIColor = .lightGray,
                 textColor: UIColor = UIColor.white){
        
        let font = UIFont.systemFont(ofSize: 15)
        self.textField.placeholder = placeholder
        self.textField.textColor = UIColor.appBlue
        
        self.textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key .foregroundColor: placeHolderColor, NSAttributedString.Key.font : font])
        self.textField.font = font
        
    }
    @IBAction func btnEye(_ sender: UIButton) {
        self.textField.isSecureTextEntry = !self.textField.isSecureTextEntry
        btnShowPass.isSelected = !btnShowPass.isSelected
        
    }
    enum Validation {
        case none
        case general
        case name
        case email
        case password
        case normal_password
        case phone
        case emailOrNumber
        case matchPass
        case iban
        // case card
    }
    
    var maxLength: Int = 160
    var viewModel: TextBoxViewModel = TextBoxViewModel()
    
    // Function for load Nib on TextBox
    func loadViewFromNib() -> UIView {
        
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "AppTextBox", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    // Function for shake view when not valid
    func shakeView() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: view.center.x - 10, y: view.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: view.center.x + 10, y: view.center.y))
        view.layer.add(animation, forKey: "position")
    }
    
    func setTitle(string: String) {
        
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    // Function for setting textFieldView
    func setTextFieldView(placeholder: String = "",
                          title: String? = nil,
                          placeHolderColor: UIColor = UIColor.lightGray,
                          textColor: UIColor = UIColor.black,
                          topLabelText: String? = nil,
                          topLabelColor: UIColor = .appDarkBlue,
                          validation: Validation = .general,
                          rightImageName: String? = nil,
                          isSystem:Bool? = false
    ){
        
        self.textField.textColor = placeHolderColor
        self.textField.backgroundColor = .clear
        self.textField.autocapitalizationType = .none
        self.textField.autocorrectionType = .no
        self.lblTop.text = topLabelText
        self.lblTop.textColor = topLabelColor
        self.textField.delegate = self
        viewModel.fieldValidation = validation
        self.setFieldType()
        
        
        self.setFont(placeholder: placeholder,
                     placeHolderColor: placeHolderColor,
                     textColor: textColor)
        
        if let name = rightImageName, name != "" ,  let image = isSystem ?? false ? UIImage(systemName:name) : UIImage(named:name) {
            self.rightImageView.image = image
        } else {
            self.rightImageView.image = nil
        }
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let t = textField.text
        self.viewModel.setFieldText(txt: t?.safelyLimitedTo(length: maxLength) ?? "")
        
        
    }
}

extension AppTextBox: TextBoxViewModelDelegate{
    
    
    func setError(with message:String) {
        errorLbl.isHidden = false
        errorLbl.text = message
    }
    func setTextField(with text:String) {
        DispatchQueue.main.async {
            self.textField.text = text
        }
    }
    func setField() {
        errorLbl.isHidden = true
    }
}

protocol TextBoxViewModelDelegate:AnyObject {
    func setError(with message:String)
    func setTextField(with text:String)
    func setField()
    
}
class TextBoxViewModel {
    
    weak var delegate:TextBoxViewModelDelegate?
    
    var textFieldText: String = ""{
        didSet{
            self.delegate?.setTextField(with: textFieldText)
        }
    }
    
    var errorMsgText: String = ""{
        didSet{
            self.delegate?.setError(with: errorMsgText)
        }
    }
    
    func setFieldText(txt: String){
        self.textFieldText = txt
        if self.textFieldText == "" {
            self.delegate?.setError(with: "")
        } else {
            self.delegate?.setField()
        }
    }
    
    
    func setErrorText(txt: String){
        self.errorMsgText = txt
    }
    
    var fieldValidation : AppTextBox.Validation = .general
    
    func checkChange() {
        
    }
    
    func validate() -> Bool{
        guard fieldValidation != .none else {
            return true
        }
        guard textFieldText != "" else {
            //            errorMsgText = "Field is required"
            
            return false
        }
        
        switch fieldValidation {
        case .none:
            
            return true
        case .general:
            if textFieldText.isEmpty {
                //                errorMsgText = "Field is required"
                return false
            }
            if (textFieldText.trimmingCharacters(in: .whitespaces).isEmpty) {
                //                errorMsgText = "Field is required"
                return false
            }
            return true
            
        case .name:
            if (textFieldText.count < 3)  {
                errorMsgText = "Name must have 3 characters"
                return false
            }
            
        case .email:
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            if !emailTest.evaluate(with: self.textFieldText) {
                errorMsgText = "Enter correct email address"
                return false
            }
            
            
        case .password:
            if textFieldText.count < 8  {
                errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase, numeric, and two special character"
                return false
                
            } else if !self.contains(case: .uppercase, in: textFieldText){
                errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase , numeric, and two special character"
                return false
                
            } else if !self.contains(case: .lowercase, in: textFieldText){
                errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase , numeric, and two special character"
                return false
                
            } else if !self.contains(case: .number, in: textFieldText){
                errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase , numeric, and two special character"
                return false
                
            } else if !self.contains(case: .special, in: textFieldText){
                errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase , numeric, and two special character"
                return false
            }
        case .normal_password:
            if textFieldText.count < 8  {
                errorMsgText = "Must contain at least 8 characters"
                return false
                
            }
            return true
        case .phone:
            if self.textFieldText.count < 10 ||
                self .textFieldText.count > 15{
                errorMsgText = "Number must be between 10-15 digits"
                return false
            }
            
            return true
            
        case .emailOrNumber:
            return true
        case .matchPass:
            if textFieldText == UserDefaults.standard.pass {
                return true
            }else{
                errorMsgText = "Password is Wrong"
                return false
            }
        case .iban:
            if (textFieldText.count < 12)  {
                errorMsgText = "IBAN must have 15 characters"
                return false
            }
        }
        self.delegate?.setField()
        return true
    }
    
    func validateForAnother(text:String) -> Bool {
        return self.textFieldText == text
    }
    
    private enum PasswordCase: String {
        case uppercase = ".*[A-Z].*[A-Z].*"
        case lowercase = ".*[a-z].*[a-z].*"
        case number = ".*[0-9]+.*"
        case special = "^(?=(.*[-_!?/<>;:{}()*@.#$%^&+=]){2,})(?=\\S+$).{4,}$"
    }
    private func contains(case pCase:PasswordCase, in searchTerm: String) -> Bool {
        
        do {
            let regex = try NSRegularExpression(pattern: pCase.rawValue)
            if let _ = regex.firstMatch(in: searchTerm, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, searchTerm.count)) {
                return true
            } else {
                return false
            }
            
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
    }
}

extension AppTextBox : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if self.viewModel.fieldValidation == .name {
            if range.location == 0, string != "", string.first! == " " {
                return false
            }
            if string != "" , ((textField.text!.count + (string.count - range.length)) >= 2), textField.text!.last! == " ", string.last! == " " {
                return false
            }
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        if self.viewModel.fieldValidation == .general{
            if range.location == 0, string != "", string.first! == " " {
                return false
            }
        }
        
        return true
    }
    
}
