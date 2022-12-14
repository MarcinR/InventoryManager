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
    // TODO: to nie powinno być przekazywane jako var, raczej jako wywołanie setup(withItem item:DatabaseItem)
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

    func openLocationDetails() {
        guard let shelfID = databaseItem?.item.shelfID else { return }
        Dependencies.databaseService.searchItemsWithCode(code: shelfID) { [weak self] result in
            switch  result {
            case .success(let items):
                guard  let item = items?.first else {
                    self?.showMessage(message: "Item not found")
                    return
                }
                self?.showDetails(forItem: item)

            case .error(let error):
                self?.showMessage(message: error.localizedDescription)
            }
        }
    }

    private func showDetails(forItem item: DatabaseItem) {
        let detailsVC = WireFrames.getItemDetailsViewController(withItem: item)
        navigationController?.pushViewController(detailsVC, animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 3 else { return }
        openLocationDetails()
    }
}
