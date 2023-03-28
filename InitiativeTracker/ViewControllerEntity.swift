//
//  ViewControllerEntity.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 28.03.23.
//

import UIKit

class ViewControllerEntity: UIViewController{
    
    @IBOutlet weak var textfield: UITextField!
    var entity: Entity?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.text = entity?.name
    }
    
    @IBAction func save(_ sender: Any) {
    }
}
