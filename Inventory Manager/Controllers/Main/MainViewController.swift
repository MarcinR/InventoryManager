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

}

extension MainViewController: ScannerDelegate {
    func cameraView() -> UIView {
        return scannerView
    }
    
    func scanCompleted(withCode code: String) {
        showMessage(message: "code: \(code)")
        
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
