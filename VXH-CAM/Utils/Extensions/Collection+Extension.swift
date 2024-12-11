//
//  Collection+Extension.swift
//  Celeritas_Test
//
//  Created by Admin on 3/30/24.
//

import Foundation

extension Collection {
    // MARK:  - Task 2
    var sortedArray:  [Int] {
        guard var array = self as? [Int] else { return [] }
        for i in 1..<array.count  {
            let key = array[i];
            var j = i - 1;
            while (j >= 0 && array[j] > key) {
                array[j + 1] = array[j];
                j = j - 1;
            }
            array[j + 1] = key;
        }
        return array
    }
    var isNotEmpty : Bool {
        return !self.isEmpty
    }
}
