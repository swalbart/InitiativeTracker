//
//  ViewControllerOptions.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 10.04.23.
//

import UIKit

class ViewControllerOptions: UIViewController {
    
    let entityData = EntityData.shared
    
    @IBOutlet weak var autoTraverseLabel: UITextField!
    @IBOutlet weak var autoTraverseSwitch: UISwitch!
    @IBOutlet weak var autoTraverseDescription: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        autoTraverseLabel.isUserInteractionEnabled = false
        autoTraverseDescription.isUserInteractionEnabled = false
    }
    
    
    @IBAction func autoTraverseToggle(_ sender: UISwitch) {
    }
    
}
