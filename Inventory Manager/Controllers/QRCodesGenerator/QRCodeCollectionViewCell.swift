//
//  QRCodeCollectionViewCell.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 21/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

struct QRCodeCellViewModel {
    let text: String?
    let image: UIImage
}

class QRCodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var label : UILabel!
    
    override func prepareForReuse() {
        label.text = nil
        imageView.image = nil
//        layer.borderWidth = 0.5
//        layer.borderColor = UIColor.black.cgColor
    }
    
    func setup(withViewModel viewModel: QRCodeCellViewModel) {
        imageView.image = viewModel.image
        label.text = viewModel.text
        label.isHidden = viewModel.text?.isEmpty ?? true
    }
}
