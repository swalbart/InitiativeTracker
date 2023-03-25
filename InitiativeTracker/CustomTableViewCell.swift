//
//  CustomTableViewCell.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 23.03.23.
//

import UIKit


class CustomTableViewCell: UITableViewCell{
    
    // connection to cell
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelInitiative: UILabel!
    @IBOutlet weak var labelHealth: UILabel!
    @IBOutlet weak var buttonEdit: UIButton!
    var isAlive: Bool!
    
    // setter for cell
    func set(name: String, health: Int, initiative: Int, isAlive: Bool){
        labelName.text = name
        labelInitiative.text = String(initiative)
        labelHealth.text = String(health)
        set(isAlive: isAlive)
    }
    
    // setter for isAlive
    func set(isAlive: Bool){
        self.isAlive = isAlive
        isDead(isDead: !isAlive)
    }
    
    // cross out text if dead
    // TODO: replace 'false' with function that checks if entity is dead
    private func isDead(isDead: Bool){
        let attributedString = NSMutableAttributedString(string: labelName.text!)
        // if dead, cross out
        if isDead {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        }
        // if no longer dead (revive/etc) remove crossed out
        else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        
        labelName.attributedText = attributedString
    }
}
