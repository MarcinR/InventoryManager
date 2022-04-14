//
//  ScanInputCell.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 13/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

@objc protocol ScannerTriggeringDelegate: AnyObject {
    func triggerScanning(withComplition complition: ((String) -> Void)?)
}

class ScanInputCell: UITableViewCell {
    @IBOutlet private var valueTextField: UITextField!
    @IBOutlet private var inputSourceButton: UIButton!
    @IBOutlet weak var sccannerTriggeringDelegate: ScannerTriggeringDelegate?

    @IBAction func didTapScanButton() {
        sccannerTriggeringDelegate?.triggerScanning(withComplition: { [weak self] code in
            self?.valueTextField.text = code
        })
    }
}
