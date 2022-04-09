//
//  UIViewController+messages.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 08/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

extension UIViewController {
    func showMessage(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
