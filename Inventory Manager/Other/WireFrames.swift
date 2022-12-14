//
//  WireFrames.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

enum Storyboard: String {
case main = "Main"
case login = "Login"
}

class WireFrames {
    private class func LoadControlerWithIdentifier( identifier: String, storyboard: Storyboard) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
    
    class func getSignInViewController() -> SignInViewController {
        return LoadControlerWithIdentifier(identifier: "SignInViewController", storyboard: .login) as! SignInViewController
    }
    
    
    class func getMainViewController() -> UIViewController {
        return LoadControlerWithIdentifier(identifier: "Main", storyboard: .main) //as! SignInViewController
    }
    
    class func getMainNavigationController() -> UINavigationController {
        return LoadControlerWithIdentifier(identifier: "MainNavigationController", storyboard: .main) as! UINavigationController
    }
    
    class func getAddItemViewController() -> UIViewController {
        return LoadControlerWithIdentifier(identifier: "AddItemViewController", storyboard: .main) //as! SignInViewController
    }
    
    class func getAddLocationViewController() -> UIViewController {
        let vc =  LoadControlerWithIdentifier(identifier: "AddItemViewController", storyboard: .main) as! AddItemViewController
        vc.createLocationMode = true
        return vc
    }
    
    class func getScannerViewController(withComplition complition: ((String) -> Void)?) -> UIViewController {
        let vc =  LoadControlerWithIdentifier(identifier: "ScannerViewController", storyboard: .main) as! ScannerViewController
        vc.complition = complition
        return vc
    }
    
    class func getEditItemViewController(withDatabaseItem item: DatabaseItem) -> UIViewController {
        let vc = LoadControlerWithIdentifier(identifier: "AddItemViewController", storyboard: .main) as! AddItemViewController
        vc.currentDatabaseItem = item
        vc.createLocationMode = item.item.isLocation ?? false
        return vc
    }
    
    
    class func getNewCodeViewController(withCode code: String) -> UIViewController {
        let vc = LoadControlerWithIdentifier(identifier: "NewCodeViewController", storyboard: .main) as! NewCodeViewController
        vc.code = code
        return vc
    }

    class func getItemDetailsViewController(withItem item: DatabaseItem) -> UIViewController {
        let vc = LoadControlerWithIdentifier(identifier: "ItemDetailsViewController", storyboard: .main) as! ItemDetailsViewController
        vc.databaseItem = item
        return vc
    }
}
