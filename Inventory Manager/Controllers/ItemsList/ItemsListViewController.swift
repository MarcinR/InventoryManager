//
//  ItemsListViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemsListViewController: UIViewController {
    private var tableView: UITableView?
    private let dataSource = ItemListDataSource()
    var items: [DatabaseItem] = [] {
        didSet {
            dataSource.updateItems(databaseItems: items)
            tableView?.reloadData()
        }
    }
    
    init(items: [DatabaseItem] ) {
        self.items = items
        dataSource.updateItems(databaseItems: items)
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("No storyboards allowed") }
    
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view = tableView
        tableView?.reloadData()
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView?.register(ItemCell.self)
        tableView?.dataSource = dataSource
        tableView?.delegate = self
    }
}

extension ItemsListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = WireFrames.getEditItemViewController(withDatabaseItem: item)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
