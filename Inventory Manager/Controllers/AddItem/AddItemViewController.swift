//
//  AddItemViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class AddItemViewController: UITableViewController {
     @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var codeTextField: UITextField!
    @IBOutlet private var locationTextField: UITextField!
    @IBOutlet private var descriptionTextField: UITextField!
//    @IBOutlet private var TextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
                                 description: descriptionTextField.text)
        
        Dependencies.databaseService.addInventoryItem(item: item) { [weak self] result in
            switch result {
                
            case .success(_):
                self?.navigationController?.popViewController(animated: true)
//                self?.showMessage(message: "Item successfuly added.")
            case .error(let error):
                self?.showMessage(message: error.localizedDescription)
            }
        }
    }
    
}
