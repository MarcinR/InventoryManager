//
//  ScannerViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 13/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ScannerViewController: UIViewController, ScannerResultDelegate {
    @IBOutlet private var cameraView: UIView!
    private var scanner: Scanner?
    var complition: ((String) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        scanner = Scanner(withCameraView: cameraView, delegate: self)
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
        scanner?.layoutPreviewLayerToContainerBouds(containerBounds: cameraView.bounds)
    }
    
    @IBAction func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func scanCompleted(withCode code: String) {
        complition?(code)
        dismiss(animated: true, completion: nil)
    }
    

}
