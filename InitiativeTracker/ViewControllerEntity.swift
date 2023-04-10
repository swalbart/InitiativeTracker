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
    
    var entity: Entity?
    var isEntityAlive: Bool?
    var isEntityFriend: Bool?
    
    weak var delegate: ViewControllerEntityDelegate?
    
    @IBOutlet weak var deadText: UITextField!
    @IBOutlet weak var aliveText: UITextField!
    @IBOutlet weak var enemyText: UITextField!
    @IBOutlet weak var friendText: UITextField!
    @IBOutlet weak var initiativeText: UITextField!
    @IBOutlet weak var healthText: UITextField!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var notesText: UITextField!
    @IBOutlet weak var isAliveSwitch: UISwitch!
    @IBOutlet weak var isFriendSwitch: UISwitch!
    @IBOutlet weak var initiativeNumber: UITextField!
    @IBOutlet weak var initiativeSubtractButton: UIButton!
    @IBOutlet weak var initiativeAddButton: UIButton!
    @IBOutlet weak var healthNumber: UITextField!
    @IBOutlet weak var healthSubtractButton: UIButton!
    @IBOutlet weak var healthAddButton: UIButton!
    @IBOutlet weak var textfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // turn off user interaction (informative text labels)
        deadText.isUserInteractionEnabled = false
        aliveText.isUserInteractionEnabled = false
        enemyText.isUserInteractionEnabled = false
        friendText.isUserInteractionEnabled = false
        initiativeText.isUserInteractionEnabled = false
        healthText.isUserInteractionEnabled = false
        titleText.isUserInteractionEnabled = false
        notesText.isUserInteractionEnabled = false
        // set colors for buttons
        initiativeAddButton.tintColor = UIColor.systemGreen
        initiativeSubtractButton.tintColor = UIColor.secondaryLabel
        healthAddButton.tintColor = UIColor.systemGreen
        healthSubtractButton.tintColor = UIColor.secondaryLabel
        
        // get all values from entity
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
        isEntityAlive = entity?.isAlive
        isEntityFriend = entity?.isFriend
        
        // set switch values (for correct visual)
        if !isEntityAlive!{
            isAliveSwitch.setOn(false, animated: false)
        }
        if !isEntityFriend!{
            isFriendSwitch.setOn(false, animated: false)
        }
    }
    
    
    
    // MARK: Save changes in Entity
    // save edited/changed name in entity
    @IBAction func save(_ sender: Any) {
        print("saving entity changes")
        // TODO: Nur Namen ändern oder Andere Werte mit gettern holen
        guard let healthStr = healthNumber.text, let initiativeStr = initiativeNumber.text else{
            return
        }
        guard let healthInt = Int(healthStr), let initiativeInt = Int(initiativeStr) else {
            return
        }
        let entity = Entity(name: textfield.text!, health: healthInt, initiative: initiativeInt, isFriend: isEntityFriend!, isAlive: isEntityAlive!)
        delegate?.viewControllerEntity(self, didSaveEntity: entity)
                
        // configure the transition
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
    }
    
    
    
    // MARK: Switches
    // switch for dead/alive (isAlive)
    @IBAction func isAliveToggle(_ sender: UISwitch) {
        if sender.isOn{
            isEntityAlive = true
        } else {
            isEntityAlive = false
        }
    }
    
    // switch for enemy/friend ( isFriend)
    @IBAction func isFriendToggle(_ sender: UISwitch) {
        if sender.isOn{
            isEntityFriend = true
        } else {
            isEntityFriend = false
        }
    }
    
    
    
    //MARK: Buttons
    // button: decrements initiative
    @IBAction func subtractInitiative(_ sender: Any) {
        var initiativeString = initiativeNumber.text!
        var initiativeInteger = Int(initiativeString)
        if initiativeInteger! > 0 {
            initiativeInteger = initiativeInteger!-1
        } else{
            initiativeInteger = 0
        }
        initiativeString = String(initiativeInteger!)
        initiativeNumber.text = initiativeString
    }
    
    // button: increments initiative
    @IBAction func addInitiative(_ sender: Any) {
        var initiativeString = initiativeNumber.text!
        var initiativeInteger = Int(initiativeString)
        if initiativeInteger! < 1000000 {
            initiativeInteger = initiativeInteger!+1
        } else{
            initiativeInteger = 1000000
        }
        initiativeString = String(initiativeInteger!)
        initiativeNumber.text = initiativeString
    }
    
    // button: decrements health
    @IBAction func subtractHealth(_ sender: Any) {
        var healthString = healthNumber.text!
        var healthInteger = Int(healthString)
        if healthInteger! > 0 {
            healthInteger = healthInteger!-1
        } else{
            healthInteger = 0
        }
        healthString = String(healthInteger!)
        healthNumber.text = healthString
    }
    
    // button: increments health
    @IBAction func addHealth(_ sender: Any) {
        var healthString = healthNumber.text!
        var healthInteger = Int(healthString)
        if healthInteger! < 1000000 {
            healthInteger = healthInteger!+1
        } else{
            healthInteger = 1000000
        }
        healthString = String(healthInteger!)
        healthNumber.text = healthString
    }
}
