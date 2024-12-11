//
//  BaseViewModel.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation

class BaseViewModel: NSObject {
    
    /// MARK:- Variables:
    var setFailureMessage: ((String) -> Void)?
    var setLoading: ((Bool) -> Void)?
    var setToastView: ((String) -> Void)?
    
    var isLoading: Bool = false {
        didSet {
            setLoading?(isLoading)
        }
    }
    var errorMessage: String = "" {
        didSet {
            setFailureMessage?(errorMessage)
        }
    }
    var setToastMessage: String = "" {
        didSet {
            setToastView?(setToastMessage)
        }
    }
}
