//
//  AddItemViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit
import MBProgressHUD

class AddItemViewController: UITableViewController {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var codeTextField: UITextField!
    @IBOutlet private var locationTextField: UITextField!
    @IBOutlet private var descriptionTextField: UITextField!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    
    var createLocationMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (createLocationMode) {
            titleLabel.text = "Add Location"
            locationLabel.text = "Parent location ID (optional)"
        }
        tableView.rowHeight =  UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        
    }
    
    @IBAction func createItem() {
        guard let code = codeTextField.text, !code.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
                  showMessage(message: "Code and name fields are required")
                  return
              }
        let item = InventoryItem(id: nil,
                                 code: code,
                                 name: name,
                                 shelfID: locationTextField.text,
                                 description: descriptionTextField.text,
                                 isLocation: createLocationMode)
        MBProgressHUD.showAdded(to: view, animated: true)
        Dependencies.databaseService.addInventoryItem(item: item) { [weak self] result in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            switch result {
            case .success(_):
                strongSelf.navigationController?.popViewController(animated: true)
            case .error(let error):
                strongSelf.showMessage(message: error.localizedDescription)
            }
        }
    }
}

extension AddItemViewController: ScannerTriggeringDelegate {
    func triggerScanning(withComplition complition: ((String) -> Void)?) {
        self.definesPresentationContext = true
        let scannerViewController = WireFrames.getScannerViewController(withComplition: complition)
        scannerViewController.modalPresentationStyle = .overCurrentContext
        present(scannerViewController, animated: true, completion: nil)
    }
}
