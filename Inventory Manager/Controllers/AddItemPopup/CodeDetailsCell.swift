//
//  CodeDetailsCell.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 27/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class CodeDetailsCell: UITableViewCell {
    @IBOutlet private var serviceNameLabel: UILabel!
    @IBOutlet private var detailsLabel: UILabel!
    @IBOutlet private var addButton: UIButton!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupWithDetails(details: String?, serviceName: String) {
        serviceNameLabel.text = serviceName
        detailsLabel.text = details ?? "Searching..."
        activityIndicator.isHidden = details != nil
        addButton.isEnabled = details != nil
    }
    
    @IBAction func didTapAddDetails() {
        
    }

}
