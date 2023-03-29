//
//  ViewControllerEntity.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 28.03.23.
//

import UIKit

protocol ViewControllerEntityDelegate: AnyObject{
    func viewControllerEntity(_ vc: ViewControllerEntity, didSaveEntity: Entity)
}

class ViewControllerEntity: UIViewController{
    
    @IBOutlet weak var textfield: UITextField!
    var entity: Entity?
    
    weak var delegate: ViewControllerEntityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.text = entity?.name
    }
    
    // save edited/changed name in entity
    @IBAction func save(_ sender: Any) {
        print("saving entity changes") // optional output
        // TODO: Nur Namen ändern oder Andere Werte mit gettern holen
        let entity = Entity(name: textfield.text!, health: entity!.health, initiative: entity!.initiative, isFriend: entity!.isFriend)
        delegate?.viewControllerEntity(self, didSaveEntity: entity)
    }
    
}
