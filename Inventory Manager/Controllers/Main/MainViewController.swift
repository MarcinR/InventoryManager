//
//  MainViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    @IBOutlet private var scannerView: UIView!
    @IBOutlet private var searchTextField: UITextField!
    @IBOutlet private var searchButton: UIButton!
//    var router: MainFlowRouter?
    private var scannedItem: DatabaseItem?
    private var scanner: Scanner?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scanner = Scanner(withCameraView: scannerView, delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scanner?.requestCaptureSessionStartRunning()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        scanner?.requestCaptureSessionStopRunning()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scanner?.layoutPreviewLayerToContainerBouds(containerBounds: scannerView.bounds)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let scannedItem = scannedItem,
              let itemDetailsVC = segue.destination as? ItemDetailsViewController
        else { return }
        itemDetailsVC.databaseItem = scannedItem
    }
    
    @IBAction func didTapAddItem() {
        navigationController?.pushViewController(WireFrames.getAddItemViewController(), animated: true)
    }
    
    @IBAction func didTapAddLocation() {
        navigationController?.pushViewController(WireFrames.getAddLocationViewController(), animated: true)
    }
    
    
    @IBAction func didTapSearchButton() {
        endEditing()
        guard let searchText = searchTextField.text, !searchText.isEmpty else { return }
        Dependencies.databaseService.searchItemsWithText(text: searchText) { [weak self] result in
            switch result {
            case .success(let items):
                guard let items = items else { return }
                self?.showList(with: items)
            case .error(let error):
                self?.showMessage(message: error.localizedDescription)
            }
        }
    }
    
}

private extension MainViewController {
    func showList(with items: [DatabaseItem]) {
         let vc = ItemsListViewController(items: items)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func showItemWithCode(code: String) {
        Dependencies.databaseService.searchItemsWithCode(code: code) { [weak self] result in
            switch  result {
            case .success(let items):
                guard  let item = items?.first else {
//                    self?.showMessage(message: "Item not found.\n Code: \(code)")
                    self?.showDetailsForCode(code: code)
                    return
                }
                self?.scannedItem = item
                self?.performSegue(withIdentifier: "ItemDetails", sender: nil)
                //self?.scanner?.requestCaptureSessionStartRunning()
            case .error(let error):
                self?.showMessage(message: error.localizedDescription)
            }
        }
    }
    
    func showDetailsForCode(code: String) {
        Dependencies.barcodeDetailsService.getBooksDBDetailsForBarcode(barcode: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.showMessage(message: details?.name ?? "No details")
                case .error(let error):
                    self?.showMessage(message: error.localizedDescription)
                }
            }
        }
    }
}

extension MainViewController: ScannerResultDelegate {
    func scanCompleted(withCode code: String) {
        showItemWithCode(code: code)
        UIPasteboard.general.string = code
        scanner?.requestCaptureSessionStartRunning()
    }
}

extension MainViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        searchButton.isEnabled = searchTextField.text.isNotEmpty()
    }
}
