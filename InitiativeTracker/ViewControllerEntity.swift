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
    
    @IBOutlet weak var isAliveSwitch: UISwitch!
    @IBOutlet weak var isFriendSwitch: UISwitch!
    @IBOutlet weak var initiativeNumber: UITextField!
    @IBOutlet weak var initiativeSubtractButton: UIButton!
    @IBOutlet weak var initiativeAddButton: UIButton!
    @IBOutlet weak var healthNumber: UITextField!
    @IBOutlet weak var healthSubtractButton: UIButton!
    @IBOutlet weak var healthAddButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    var entity: Entity?
    
    weak var delegate: ViewControllerEntityDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let initiative = entity?.initiative{
            initiativeNumber.text = String(initiative)
        } else {
            initiativeNumber.text = "0"
        }
        if let health = entity?.health{
            healthNumber.text = String(health)
        }else {
            healthNumber.text = "0"
        }
            textfield.text = entity?.name
    }
    
    // save edited/changed name in entity
    @IBAction func save(_ sender: Any) {
        print("saving entity changes") // optional output
        // TODO: Nur Namen ändern oder Andere Werte mit gettern holen
        guard let healthString = healthNumber.text, let initiativeString = initiativeNumber.text else{
            //TODO: handle the case where healtNumber.text or initiativeNumber.text is nil
            return
        }
        guard let healthInt = Int(healthString), let initiativeInt = Int(initiativeString) else {
            //TODO: Exceptionhandling
            return
        }
        let entity = Entity(name: textfield.text!, health: healthInt, initiative: initiativeInt, isFriend: entity!.isFriend)
        delegate?.viewControllerEntity(self, didSaveEntity: entity)
    }
    
}
