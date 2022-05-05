//
//  NewCodeViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 28/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class NewCodeViewController: UIViewController {
    @IBOutlet private var tableView: UITableView?
    @IBOutlet private var headerLabel: UILabel!
    private var isbnDetails: String?
    private var monsterDetails: String?
    
    var code: String? {
        didSet {
            guard let code = code else { return }
            searchISBN(forCode: code)
            searchMonsterDB(forCode: code)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.rowHeight = UITableView.automaticDimension
        headerLabel.text = code
    }
    
    private func searchISBN(forCode code: String) {
        Dependencies.barcodeDetailsService.getBooksDBDetailsForBarcode(barcode: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.isbnDetails = details?.name
                case .error(let error):
                    self?.isbnDetails = error.localizedDescription
                }
                self?.tableView?.reloadData()
            }
        }
    }
    
    private func searchMonsterDB(forCode code: String) {
        Dependencies.barcodeDetailsService.getMonsterDBDetailsForBarcode(barcode: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.monsterDetails = details?.name
                case .error(let error):
                    self?.monsterDetails = error.localizedDescription
                }
                self?.tableView?.reloadData()
            }
        }
    }

}

extension NewCodeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let detailsCell = tableView.dequeueReusableCell(withIdentifier: "CodeDetailsCell", for: indexPath) as? CodeDetailsCell else { return UITableViewCell() }
        switch indexPath.row {
        case 0:
            detailsCell.setupWithDetails(details: isbnDetails, serviceName: "ISBN")
        case 1:
            detailsCell.setupWithDetails(details: monsterDetails, serviceName: "Monster DB")
        default:
            detailsCell.setupWithDetails(details: nil, serviceName: "")
        }
        return detailsCell
    }
    
    
}
