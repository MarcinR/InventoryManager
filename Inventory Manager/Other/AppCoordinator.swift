//
//  AppCoordinator.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 20/09/2019.
//  Copyright © 2019 A. All rights reserved.
//

import UIKit
import Firebase

class AppCoordinator {
    private let mainNavigationController: UINavigationController!
    
    init(mainNavigationController: UINavigationController) {
        self.mainNavigationController = mainNavigationController
        addLoginStateListener()
    }
    
    func addLoginStateListener() {
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            var newFlowViewController: UIViewController
            if user != nil, let uid = auth.currentUser?.uid {
                Dependencies = AppDependencies(uid: uid)
                newFlowViewController = WireFrames.getMainViewController()
            } else {
                newFlowViewController = WireFrames.getSignInViewController()
            }
            self?.mainNavigationController.setViewControllers([newFlowViewController], animated: true)
        }
    }
    
}
