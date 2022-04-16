//
//  ItemsListViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemsListViewController: UIViewController {
    private var tableView: UITableView!
    var items: [DatabaseItem] = []
    
    init(items: [DatabaseItem] ) {
        self.items = items
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("No storyboards allowed") }
    
    
    override func loadView() {
        tableView = UITableView(frame: .zero, style: .grouped)
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    private func setupTableView() {
        tableView.register(ItemCell.self)
        tableView.dataSource = self
        tableView.delegate = self
    }

}

extension ItemsListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuseIdentifier, for: indexPath) as! ItemCell
        let item = items[indexPath.row]
        cell.bind(with: item)
        
        return cell
    }
}

extension ItemsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        let vc = WireFrames.getEditItemViewController(withDatabaseItem: item)
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
