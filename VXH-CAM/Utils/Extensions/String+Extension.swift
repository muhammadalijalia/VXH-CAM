//
//  String+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation

extension String {
    // MARK:  - Task 1
    var isPalindrome : Bool {
        let removeOtherthanLetter = self.lowercased().filter { $0.isLetter }
        return removeOtherthanLetter == String(removeOtherthanLetter.reversed())
    }
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
}
