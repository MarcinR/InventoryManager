//
//  Reusable.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

public protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable where Self: UIView {
    public static var reuseIdentifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UITableView {
    public func register<Cell: Reusable>(_: Cell.Type) where Cell: UITableViewCell {
        register(Cell.self, forCellReuseIdentifier: Cell.reuseIdentifier)
    }

//    public func registerTableViewHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) where T: Reusable {
//        register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
//    }

    public func dequeueReusableCell<Cell: UITableViewCell>(
        forIndexPath indexPath: IndexPath
    ) -> Cell where Cell: Reusable {
        return dequeueReusableCell(
            withIdentifier: Cell.reuseIdentifier,
            for: indexPath
        ) as! Cell
    }
}
