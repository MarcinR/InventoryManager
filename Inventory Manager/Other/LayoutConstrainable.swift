//
//  LayoutConstrainable.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

public protocol LayoutConstrainable {
    var layoutConstraints: [NSLayoutConstraint] { get }
}

extension NSLayoutConstraint: LayoutConstrainable {
    public var layoutConstraints: [NSLayoutConstraint] { return [self] }
}

extension Array: LayoutConstrainable where Element == NSLayoutConstraint {
    public var layoutConstraints: [NSLayoutConstraint] { return self }
}

extension NSLayoutConstraint {
    public static func activate(_ constrainables: LayoutConstrainable...) {
        activate(constrainables.flatMap({ $0.layoutConstraints }))
    }
    
    public static func deactivate(_ constrainables: LayoutConstrainable...) {
        deactivate(constrainables.flatMap({ $0.layoutConstraints }))
    }
}
