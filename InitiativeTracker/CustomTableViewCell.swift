//
//  CustomTableViewCell.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 23.03.23.
//

import Foundation
import UIKit

class CustomTableViewCell: UITableViewCell{
    
    let customLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Hintergrundfarbe der Zelle
        self.backgroundColor = UIColor.yellow
        
        // Runde Ecken hinzufügen
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        // Custom Label hinzufügen
        customLabel.textColor = UIColor.red
        customLabel.font = UIFont.boldSystemFont(ofSize: 16)
        customLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(customLabel)
        
        // Constraints für das Label hinzufügen
        NSLayoutConstraint.activate([
            customLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            customLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            customLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            customLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder: ) has not been implemented")
    }
    
    func configure(text: String){
        customLabel.text = text
    }
}
