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
        self.scanner = Scanner(withDelegate: self)
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
        scanner?.layoutPreviewLayer()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let item = scannedItem,
              let itemDetailsVC = segue.destination as? ItemDetailsViewController
        else { return }
        itemDetailsVC.item = item
    }
}

private extension MainViewController {
    private func showItemWithCode(code: String) {
        Dependencies.databaseService.searchItemsWithCode(code: code) { [weak self] result in
            switch  result {
            case .success(let items):
                guard  let item = items?.first else {
                    self?.showMessage(message: "Item not found.\n Code: \(code)")
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
}

extension MainViewController: ScannerDelegate {
    func cameraView() -> UIView {
        return scannerView
    }
    
    func scanCompleted(withCode code: String) {
        showItemWithCode(code: code)
        UIPasteboard.general.string = code
        scanner?.requestCaptureSessionStartRunning()
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        print("metadataObj:::")
        print(metadataObjects)
        print("metaOutput:::")
        print(output)
        guard let scanner = self.scanner else {
                  return
              }
              scanner.metadataOutput(output,
                                     didOutput: metadataObjects,
                                     from: connection)
    }
    
    
}
