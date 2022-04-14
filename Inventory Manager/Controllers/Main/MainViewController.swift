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
    private var scannedItem: InventoryItem?
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
        guard let item = scannedItem,
              let itemDetailsVC = segue.destination as? ItemDetailsViewController
        else { return }
        itemDetailsVC.item = item
    }
    
    @IBAction func didTapAddItem() {
        navigationController?.pushViewController(WireFrames.getAddItemViewController(), animated: true)
    }
    
    @IBAction func didTapAddLocation() {
        navigationController?.pushViewController(WireFrames.getAddLocationViewController(), animated: true)
    }
    
    
}

private extension MainViewController {
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
        Dependencies.barcodeDetailsService.getDetailsForBarcode(barcode: code) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self?.showMessage(message: details.description ?? "No details")
                    return
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
