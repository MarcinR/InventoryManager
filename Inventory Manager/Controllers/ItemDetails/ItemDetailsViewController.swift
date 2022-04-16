//
//  ItemDetailsViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 10/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UITableViewController {
    
    @IBOutlet private var idLabel: UILabel!
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var codeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    // TODO: to nie powinno być przekazywane jako var
    var  databaseItem: DatabaseItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        guard let dbItem = databaseItem else { return }
        let item = dbItem.item
        idLabel.text =  dbItem.id
        nameLabel.text = item.name
        codeLabel.text = item.code
        locationLabel.text = item.shelfID
        descriptionLabel.text = item.description
    }


    @IBAction func didTapEditButton() {
        guard let item = databaseItem else { return }
        let viewController = WireFrames.getEditItemViewController(withDatabaseItem: item)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
