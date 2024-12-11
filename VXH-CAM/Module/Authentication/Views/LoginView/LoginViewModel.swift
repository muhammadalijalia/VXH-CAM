//
//  LoginViewModel.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation

protocol LoginViewDelegate : AnyObject {
    
    func loginSuccess()
    func ifError(error: ServerErrorResponse)
}

class LoginViewModel: BaseViewModel {
  
    var delegate: LoginViewDelegate?
    
    init(binding: LoginViewDelegate) {
        super.init()
        self.delegate = binding
    }
    
    func login() {
        guard self.isValidate() else {
            return
        }
        self.isLoading = true
       
    }
    func isValidate() -> Bool{
        
        let isErrorExist = false
        
//        if !email.validate(){
//            if email.textFieldText.isEmpty {
//                email.errorMsgText = "Email is Required"
//            } else {
//                email.errorMsgText = "Enter Valid Email"
//            }
//            isErrorExist = true
//        }
//        
//        if !password.validate(){
//            
//            if password.textFieldText.isEmpty {
//                password.errorMsgText = "Password is Required"
//            } else {
//                password.errorMsgText = "Must contain at least 8 characters, two uppercase, two lowercase, numeric, and two special character"
//            }
//            isErrorExist = true
//        }
        
        return !isErrorExist
    }
}
