//
//  UITableVIew+Extensionn.swift
//  Celeritas_Test
//
//  Created by Admin on 3/31/24.
//

import Foundation
import UIKit
extension UITableView{
    func cell<T: UITableViewCell>(identifire:String = T.self.identifire, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: identifire, for: indexPath) as? T else {
            fatalError("Unable to Dequeue Reusable Table View Cell")
        }
        return cell
    }
    func registerNib<T:UITableViewCell>(cellType: T.Type, identifier: String = T.identifire) {
        self.register(T.nib, forCellReuseIdentifier: identifier)
    }
    func lastIndexpath() -> IndexPath {
            let section = max(numberOfSections - 1, 0)
            let row = max(numberOfRows(inSection: section) - 1, 0)

            return IndexPath(row: row, section: section)
        }
    func endRefreshing() {
        if let refreshControl = self.refreshControl {
            refreshControl.endRefreshing()
        }
    }
}
