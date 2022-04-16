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
    @IBOutlet private var createButton: UIButton!
    
    var createLocationMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight =  UITableView.automaticDimension
        tableView.estimatedRowHeight = 80.0
        setupView()
    }
    //----------------------------------------------------------------------------------------------------<<<<<<<
    // TODO wydzielić logikę związaną z edycją do osobnego controllera dziedziczącego z tego
    var currentDatabaseItem: DatabaseItem?
    private func setupView() {
        
        if (createLocationMode) {
            titleLabel.text = "Add Location"
            locationLabel.text = "Parent location ID (optional)"
        }
        
        guard let databaseItem = currentDatabaseItem else { return }
        titleLabel.text = databaseItem.id
        let item = databaseItem.item
        codeTextField.text = item.code
        locationTextField.text = item.shelfID
        descriptionTextField.text = item.description
        nameTextField.text = item.name
        createButton.isHidden = true
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(updateCurrentDatabaseItem))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func updateCurrentDatabaseItem() {
        guard let currentItemID = currentDatabaseItem?.id,
              let updatedInventoryItem = createInventoryItemModel()
        else { return }
        let newDatabaseItem = DatabaseItem(id: currentItemID, item: updatedInventoryItem)
        MBProgressHUD.showAdded(to: view, animated: true)
        Dependencies.databaseService.updateItem(item: newDatabaseItem) { [weak self] result in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            switch result {
            case .success:
                self?.navigationController?.popViewController(animated: true)
                return
            case .error(let error):
                strongSelf.showMessage(message: error.localizedDescription)
                return
            }
        }
        
    }
    //---------------------------------------------------------------------------------------------------->>>>>>>>
    
    @IBAction func didTapCreatetem() {
        guard let inventoryItem = createInventoryItemModel() else { return }
        MBProgressHUD.showAdded(to: view, animated: true)
        Dependencies.databaseService.searchItemsWithCode(code: inventoryItem.code) { [weak self] result in
            guard let strongSelf = self else { return }
            MBProgressHUD.hide(for: strongSelf.view, animated: true)
            switch result {
            case .success(let items):
                if let items = items, !items.isEmpty {
                    strongSelf.showMessage(message: "There is existing item with this code")
                    return
                }
                strongSelf.createItemInDatabase(item: inventoryItem)
            case .error(let error):
                strongSelf.showMessage(message: error.localizedDescription)
                return
            }
        }
    }
    
    private func createInventoryItemModel() -> InventoryItem? {
        guard let code = codeTextField.text, !code.isEmpty,
              let name = nameTextField.text, !name.isEmpty else {
                  showMessage(message: "Code and name fields are required")
                  return nil
              }
        return InventoryItem(code: code,
                                 name: name,
                                 shelfID: locationTextField.text,
                                 description: descriptionTextField.text,
                                 isLocation: createLocationMode)
    }
    
    private func createItemInDatabase(item: InventoryItem) {
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
