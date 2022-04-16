//
//  ItemCell.swift
//  Inventory Manager
//
//  Created by Marcin Ratajczak on 15/04/2022.
//  Copyright © 2022 A. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell, Reusable {
    private var stackView = UIStackView()
    private var nameLabel = UILabel()
    private var descriptionLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        selectionStyle = .none
    }
    
    func bind(with item:DatabaseItem) {
        nameLabel.text = item.item.name
        descriptionLabel.text = item.item.description
    }
    
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("No storyboards allowed") }
}

private extension ItemCell {
    func setupSubviews() {
        setupStackView()
        setupLabels()
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 6.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate(
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10.0),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.0),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10.0)
        )
    }
    
    func setupLabels() {
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        stackView.addArrangedSubview(nameLabel)
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor.darkGray
        stackView.addArrangedSubview(descriptionLabel)
    }
}
