//
//  CodeScanner.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 09/04/2022.
//  Copyright © 2022 A. All rights reserved.
//
import Foundation
import UIKit
import AVFoundation

protocol ScannerResultDelegate: AnyObject {
    func scanCompleted(withCode code: String)
}

class Scanner: NSObject, AVCaptureMetadataOutputObjectsDelegate {
    public weak var delegate: ScannerResultDelegate?
    private var captureSession : AVCaptureSession?
    private var  previewLayer: AVCaptureVideoPreviewLayer?
    
    init(withCameraView cameraView: UIView, delegate: ScannerResultDelegate) {
        self.delegate = delegate
        super.init()
        self.scannerSetupWithCameraView(cameraView: cameraView)
    }
    
    private func scannerSetupWithCameraView(cameraView: UIView)  {
        guard let captureSession = self.createCaptureSession() else {
            return
        }
        self.captureSession = captureSession
        let previewLayer = self.createPreviewLayer(withCaptureSession: captureSession,
                                                   view: cameraView)
        self.previewLayer = previewLayer
        cameraView.layer.addSublayer(previewLayer)
    }
    
    private func createCaptureSession() -> AVCaptureSession? {
        do {
            guard let captureDevice = AVCaptureDevice.default(for: .video) else { return nil }
            let captureSession = AVCaptureSession()
            
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            let metaDataOutput = AVCaptureMetadataOutput()
            
            // Add device input
            if captureSession.canAddInput(deviceInput) && captureSession.canAddOutput(metaDataOutput) {
                captureSession.addInput(deviceInput)
                captureSession.addOutput(metaDataOutput)
                
//                guard let delegate = self.delegate else { return nil }
                
                metaDataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metaDataOutput.metadataObjectTypes = self.metaObjectTypes()
                
                return captureSession
            }
        }
        catch
        {
            // Handle error
        }
        
        return nil
    }
    
    private func createPreviewLayer(withCaptureSession captureSession: AVCaptureSession,
                                    view: UIView) -> AVCaptureVideoPreviewLayer {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        return previewLayer
    }
    
    private func metaObjectTypes() -> [AVMetadataObject.ObjectType] {
        return [.qr,
                .code128,
                .code39,
                .code39Mod43,
                .code93,
                .ean13,
                .ean8,
                .interleaved2of5,
                .itf14,
                .pdf417,
                .upce
        ]
    }
    
    public func metadataOutput(_ output: AVCaptureMetadataOutput,
                         didOutput metadataObjects: [AVMetadataObject],
                         from connection: AVCaptureConnection) {
        self.requestCaptureSessionStopRunning()
        
        guard let metadataObject = metadataObjects.first,
            let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject,
            let scannedValue = readableObject.stringValue,
            let delegate = self.delegate else {
                return
        }
        let finalValue = getId(fromCode: scannedValue)
        delegate.scanCompleted(withCode: finalValue)
    }
    
    private func getId(fromCode code: String) -> String {
        return code.replacingOccurrences(of: "inventory://", with: "")
    }
    
    public func requestCaptureSessionStartRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    
    public func requestCaptureSessionStopRunning() {
        self.toggleCaptureSessionRunningState()
    }
    
    public func layoutPreviewLayerToContainerBouds(containerBounds: CGRect) {
        guard previewLayer?.frame != containerBounds else { return }
        previewLayer?.frame = containerBounds
    }
    
    private func toggleCaptureSessionRunningState() {
        guard let captureSession = self.captureSession else { return }
        
        if !captureSession.isRunning {
            captureSession.startRunning()
        } else {
            captureSession.stopRunning()
        }
    }
}
