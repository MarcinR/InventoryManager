//
//  QRCodesCollectionViewController.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 21/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class QRCodesCollectionViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var minusButton: UIButton!
    @IBOutlet private var plusButton: UIButton!
    private let cellsInRow = [5, 9, 14]
    private var chosenSizeIndex = 0
    private var viewModelsDictionary: [Int: QRCodeCellViewModel] = [:]
    private let verticalMarginPercentage = 0.08
//    private let horizontalMarginPercentage = 0.04
    private let a4Ratio = 273.0/200.0
    private var cellSize: CGSize?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.layout
    }
    override func didReceiveMemoryWarning() {
        viewModelsDictionary = [:]
        chosenSizeIndex = 0
        
        collectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        collectionView.reloadData()
    }
    
    @IBAction func didTapMinusButton() {
        chosenSizeIndex = max(chosenSizeIndex - 1, 0)
        minusButton.isHidden = chosenSizeIndex == 0
        plusButton.isHidden = false
        cellSize = calculatedCellSize()
        collectionView.reloadData()
    }
    
    @IBAction func didTapPlusButton() {
        chosenSizeIndex = min(chosenSizeIndex + 1, cellsInRow.count - 1)
        plusButton.isHidden = chosenSizeIndex == cellsInRow.count - 1
        minusButton.isHidden = false
        cellSize = calculatedCellSize()
        collectionView.reloadData()
    }
    
    @IBAction func didTapShareButton() {
        let image = collectionView.getImage(scale: 8.0)
                let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func calculatedCellSize() -> CGSize {
        let width = (collectionView.bounds.width * 0.92) / CGFloat(cellsInRow[chosenSizeIndex])
//        let height = width * a4Ratio
        return CGSize(width: width, height: width)
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    
    
}

extension QRCodesCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let size = cellSize { return size }
        let size = calculatedCellSize()
        cellSize = size
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let verticalInset = collectionView.bounds.height * 0.04
        let horizontalInset = collectionView.bounds.width * 0.023
        return UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

extension QRCodesCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let collumns = cellsInRow[chosenSizeIndex]
        let rows = floor(Double(collumns) * a4Ratio)
        return collumns * Int(rows)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "QRCodeCollectionViewCell", for: indexPath) as! QRCodeCollectionViewCell
        cell.setup(withViewModel: viewModel(forIndex: indexPath.item))
        
        return cell
    }
    
    
    private func viewModel(forIndex index: Int) -> QRCodeCellViewModel {
        if let model = viewModelsDictionary[index] { return model }
        let code = NanoID.new()
        let image = generateQRCode(from: "inventory://" + code) ?? UIImage()
        let viewModel = QRCodeCellViewModel(text: code, image: image)
        viewModelsDictionary[index] = viewModel
        return viewModel
    }
    
}

extension UIView {
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }

    func getImage(scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale

        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)

        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }

        return image
    }
}
