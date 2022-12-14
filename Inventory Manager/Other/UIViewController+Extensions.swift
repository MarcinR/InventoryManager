//
//  UIViewController+Extensions.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 13/12/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

extension UIViewController {
    func wrapInNavigationViewController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
}
