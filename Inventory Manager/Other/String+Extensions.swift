//
//  String+Extensions.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 08/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import Foundation

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func isValidPassword() -> Bool {
        return self.count > 5
    }
}
extension Optional where Wrapped == String {

    
    func isNotEmpty() -> Bool {
        guard let strongSelf = self else { return false }
        return !strongSelf.isEmpty
    }
}
