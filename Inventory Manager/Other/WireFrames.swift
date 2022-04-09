//
//  WireFrames.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

enum Storyboard: String {
case Main = "Main"
case Login = "Login"
}

class WireFrames {
    private class func LoadControlerWithIdentifier( identifier: String, storyboard: Storyboard) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    class func getSignInViewController() -> SignInViewController {
        return LoadControlerWithIdentifier(identifier: "SignInViewController", storyboard: .Login) as! SignInViewController
    }
    
    
    class func getMainViewController() -> UIViewController {
        return LoadControlerWithIdentifier(identifier: "Main", storyboard: .Main) //as! SignInViewController
    }
    
    
    
    class func getMainNavigationController() -> UINavigationController {
        return LoadControlerWithIdentifier(identifier: "MainNavigationController", storyboard: .Main) as! UINavigationController
    }
}
