//
//  ViewControllerBoard.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 22.03.23.
//

import UIKit

class ViewControllerBoard: UIViewController{
    
    // enables use of shared EntityData
    let entityData = EntityData.shared
    
    // global variable to track diyplayed entity
    var currentPosition = 0
    var isAttack = false
    var isHeal = false
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var attackButton: UIButton!
    @IBOutlet weak var healButton: UIButton!
    @IBOutlet weak var currentInitiative: UILabel!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentHealth: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        entityData.load()
        sortEntitys()
    }
    
    
    
    // MARK: Storyboard connections
    // move to storyboard "Main"
    @IBAction func buttonToMain(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateInitialViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        windowScene.windows.first?.rootViewController = vc
    }
    
    
    
    // MARK: vcEntity connection
    // move to and send entity data to ViewControllerEntity
    @IBSegueAction func toViewControllerEntity(_ coder: NSCoder) -> ViewControllerEntity? {
        let vc = ViewControllerEntity(coder: coder)
        // create new entity button tapped
        vc?.entity = Entity(name: "New Entity", health: 0, initiative: 0, isFriend: true, isAlive: true)
        vc?.delegate = self
        return vc
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Hier wird das ausgewählte Entity gefunden und das Pop-up-Fenster geöffnet
        // only do if it is an attack
        if isAttack {
            let entity = entityData.groupA[indexPath.row]
            showDamageAlert(for: entity)
            attackButton.tintColor = UIColor.tintColor
        }
        if isHeal {
            let entity = entityData.groupA[indexPath.row]
            showHealAlert(for: entity)
            healButton.tintColor = UIColor.tintColor
        }
        else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerEntity") as! ViewControllerEntity
            if let indexpath = tableView.indexPathForSelectedRow{
                let entity = entityData.groupA[indexpath.row]
                vc.entity = entity
                vc.delegate = self
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    // MARK: Navigationbar
    @IBAction func sortEntityListButton(_ sender: Any) {
        sortEntitys()
        tableView.reloadData()
    }
    
    // toggle editabilty
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    
    
    // MARK: Display: current entity
    // place entity at pos n in show box below table
    func setShowboxEntity(pos: Int) {
        guard pos >= currentPosition && pos < entityData.groupA.count else{
            return // index out of range
        }
        
        let entity = entityData.groupA[pos]
        currentInitiative.text = String(entity.initiative)
        currentHealth.text = String(entity.health)
        currentName.text = entity.name
    }
    
    func resetDisplayValues() {
        currentInitiative.text = "-"
        currentHealth.text = "-"
        currentName.text = "waiting for entities"
    }
    
    
    
    // MARK: Sorting
    // sorting all entites (most initiative top)
    func sortEntitys() {
        entityData.groupA.sort {
            $0.initiative > $1.initiative
        }
        entityData.save()
        //tableView.reloadData()
        if entityData.groupA.count > 0 {
            currentPosition = 0
            setShowboxEntity(pos: currentPosition)
        } else {
            resetDisplayValues()
        }
    }
    
    
    
    // MARK: Traversing indexes
    func previousEntity(){
        var count = entityData.groupA.count
        // search for next alive member
        while count >= 0 {
            // traverse through all indexes
            if currentPosition > 0 {
                currentPosition -= 1
            } else {
                currentPosition = entityData.groupA.count-1
            }
            // check if isAlive
            if entityData.groupA[currentPosition].isAlive {
                count = 0 // break the loop
                setShowboxEntity(pos: currentPosition)
            }
            count -= 1
        }
        if count == 0 {
            print("Error.priviousEntity(): there is no alive entity left but there should be.")
        }
    }
    
    func nextEntity(){
        var count = entityData.groupA.count
        // search for next alive member
        while count >= 0 {
            // traverse through all indexes
            if currentPosition < entityData.groupA.count-1 {
                currentPosition += 1
            } else {
                currentPosition = 0
            }
            // check if isAlive
            if entityData.groupA[currentPosition].isAlive {
                count = 0 // break the loop
                setShowboxEntity(pos: currentPosition)
            }
            count -= 1
        }
        if count == 0 {
            print("Error.nextEntity(): there is no alive entity left but there should be.")
        }
    }
    
    
    
    // MARK: Player button actions
    @IBAction func previousButton(_ sender: Any) {
        if !entityData.groupA.isEmpty {
            previousEntity()
        } else {
            resetDisplayValues()
        }
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if !entityData.groupA.isEmpty {
            nextEntity()
        } else {
            resetDisplayValues()
        }
    }
    
    @IBAction func attackButton(_ sender: Any) {
        isAttack = !isAttack
        isHeal = false
        if isAttack {
            attackButton.tintColor = UIColor.systemRed
            healButton.tintColor = UIColor.tintColor
        } else {
            attackButton.tintColor = UIColor.tintColor
        }
    }
    
    @IBAction func healButton(_ sender: Any) {
        isHeal = !isHeal
        isAttack = false
        if isHeal {
            healButton.tintColor = UIColor.systemGreen
            attackButton.tintColor = UIColor.tintColor
        } else {
            healButton.tintColor = UIColor.tintColor
        }
    }
    
    
    
    // MARK: Attack entity
    func applyDamage(to entity: Entity, with damage: Int) {
        var newHealth = entity.health - damage
        var isStilAlive = true
        if newHealth <= 0 {
            newHealth = 0
            isStilAlive = false
        }
        let updatedEntity = Entity(name: entity.name, health: newHealth, initiative: entity.initiative, isFriend: entity.isFriend, isAlive: isStilAlive)
        
        // save data
        entityData.groupA[tableView.indexPathForSelectedRow!.row] = updatedEntity
        tableView.reloadData()
        entityData.save()
        // un-select attack
        isAttack = false
    }

    // MARK: Heal entity
    func applyHeal(to entity: Entity, with heal: Int) {
        let newHealth = entity.health + heal
        let isStilAlive = true
        let updatedEntity = Entity(name: entity.name, health: newHealth, initiative: entity.initiative, isFriend: entity.isFriend, isAlive: isStilAlive)
        
        // save data
        entityData.groupA[tableView.indexPathForSelectedRow!.row] = updatedEntity
        tableView.reloadData()
        entityData.save()
        // un-select heal
        isHeal = false
    }
    
    
    
    // MARK: Alerts
    // show damageAlert
    func showDamageAlert(for entity: Entity) {
        let alertController = UIAlertController(title: "Schaden des Angriffs:", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "Bestätigen", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text, let damage = Int(text) else { return }
            
            // Hier wird der Schaden am Entity angewendet
            self.applyDamage(to: entity, with: damage)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // show healAlert
    func showHealAlert(for entity: Entity) {
        let alertController = UIAlertController(title: "Höhe der Heilung:", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.keyboardType = .numberPad
        }
        
        let confirmAction = UIAlertAction(title: "Bestätigen", style: .default) { _ in
            guard let text = alertController.textFields?.first?.text, let heal = Int(text) else { return }
            
            // Hier wird die Heilung am Entity angewendet
            self.applyHeal(to: entity, with: heal)
        }
        alertController.addAction(confirmAction)
        
        let cancelAction = UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
}



// MARK: Delegate
// Delegate
extension ViewControllerBoard: UITableViewDelegate{
    // swipe right behaviour of cells
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // swipe message and actions
        // style: .normal = gray color
        let action = UIContextualAction(style: .normal, title: "Toggle death"){ action, view, complete in
            // replace entity by a new entity with toggeled 'isAlive'-value
            let entity = self.entityData.groupA[indexPath.row].isAliveToggled()
            self.entityData.groupA[indexPath.row] = entity
            
            //update 'isAlive'-value to cell
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            cell.set(isAlive: entity.isAlive)
            
            // reset swipe animation
            complete(true)
            print("toggeled 'isAlive'-value of entity")
            let entityIsAlive = self.entityData.groupA[self.currentPosition].isAlive
            if !entityIsAlive {
                self.nextEntity()
            }
            self.entityData.save()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    // swipe left behaviour of cells
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}



// MARK: DataSource
//DataSource
extension ViewControllerBoard: UITableViewDataSource{
    
    // amount of sections in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // amount of cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityData.groupA.count
    }
    
    // apply entity values to display in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.delegate = self
        // selection of the next entity
        let entity = entityData.groupA[indexPath.row]
        // setting entityvalues to cell
        cell.set(name: entity.name, health: entity.health, initiative: entity.initiative, isAlive: entity.isAlive)
        return cell
    }
    
    // delete entity in entities-array and cell in tableview
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            entityData.groupA.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        resetDisplayValues()
        entityData.save()
    }
    
    // reodering cells
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // remove cell from current spot
        let entity = entityData.groupA.remove(at: sourceIndexPath.row)
        // insert cell in new spot
        entityData.groupA.insert(entity, at: destinationIndexPath.row)
        entityData.save()
        // show first element in showbox (no sort) to keep top entity shown
        setShowboxEntity(pos: 0)
    }
}



// MARK: Saving changes
// save created or edited entity
extension ViewControllerBoard: ViewControllerEntityDelegate{
    func viewControllerEntity(_ vc: ViewControllerEntity, didSaveEntity entity: Entity) {
        if let indexPath = tableView.indexPathForSelectedRow{
            // edited entity
            entityData.groupA[indexPath.row] = entity
            entityData.save()
            tableView.reloadRows(at: [indexPath], with: .none)
        }
        else{
            // created entity
            entityData.groupA.append(entity)
            entityData.save()
            tableView.insertRows(at: [IndexPath(row: entityData.groupA.count-1, section: 0)], with: .automatic)
        }
        sortEntitys()
        // dismisses the poped up view (not in use: view is fullscreen)
        // dismiss(animated: true, completion: nil)
    }
}



// MARK: Storing data persistent
// keep data persistent in array
extension ViewControllerBoard: CustomTableViewCellDelegate{
    func customTableViewCell(_ cell: CustomTableViewCell, didChangeIsAlive isAlive: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else{
            return
        }
        // it is not possible to mutate 'entity' because it is a constand
        // instead a new entity gets created to replace the old
        let entity = entityData.groupA[indexPath.row]
        let newEntity = Entity(name: entity.name, health: entity.health, initiative: entity.initiative, isFriend: entity.isFriend, isAlive: entity.isAlive)
        entityData.groupA[indexPath.row] = newEntity
        entityData.save()
    }
}
