//
//  Userdefaults+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation

extension UserDefaults {
    var pass: String {
        get {
            return UserDefaults.standard.string(forKey: "pass") ?? ""
        }set {
            UserDefaults.standard.set(newValue, forKey: "pass")
        }
    }
}
