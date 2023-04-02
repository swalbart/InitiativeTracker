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
    
    // global variable to track 
    var currentPosition = 0
    
    /*
    var entities = [
        Entity(name: "BBEG", health: 100, initiative: 18, isFriend: false, isAlive: true),
        Entity(name: "Hero", health: 35, initiative: 16, isFriend: true, isAlive: true),
        Entity(name: "NPC", health: 28, initiative: 5, isFriend: true, isAlive: true),
        Entity(name: "Al", health: 0, initiative: 8, isFriend: false, isAlive: false),
    ]*/

    
    @IBOutlet weak var currentInitiative: UILabel!
    @IBOutlet weak var currentName: UILabel!
    @IBOutlet weak var currentHealth: UILabel!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
        entityData.load()
        sortEntitys()
    }
    
    // move to storyboard "Main"
    @IBAction func buttonToMain(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateInitialViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        windowScene.windows.first?.rootViewController = vc
    }
    
    // toggle editabilty
    @IBAction func startEditing(_ sender: Any) {
        tableView.isEditing = !tableView.isEditing
    }
    
    // send entity data to ViewControllerEntity
    @IBSegueAction func toViewControllerEntity(_ coder: NSCoder) -> ViewControllerEntity? {
        let vc = ViewControllerEntity(coder: coder)
        
        // cell tapped to edit
        if let indexpath = tableView.indexPathForSelectedRow{
            let entity = entityData.groupA[indexpath.row]
            vc?.entity = entity
        }
        // create new entity button tapped
        else{
            vc?.entity = Entity(name: "New Entity", health: 0, initiative: 0, isFriend: true, isAlive: true)
        }
        vc?.delegate = self
        return vc
    }
    
    // sorting all entites (most initiative top)
    func sortEntitys() {
        entityData.groupA.sort {
            $0.initiative > $1.initiative
        }
        entityData.save()
        if entityData.groupA.count > 0 {
            currentPosition = 0
            setShowboxEntity(pos: currentPosition)
        } else {
            currentInitiative.text = "-"
            currentHealth.text = "-"
            currentName.text = "waiting for entities"
        }
    }
    
    /* Ersetzt von setShowboxEntity
    // place the entity with the highest initiative in show box below table
    func setHighestInitiativeEntity() {
        // converting Integers to stings
        if let firstInitiative = entityData.groupA.first?.initiative{
            currentInitiative.text = String(firstInitiative)
        } else {
            currentInitiative.text = "Err"
        }
        if let firstHealth = entityData.groupA.first?.health{
            currentHealth.text = String(firstHealth)
        } else {
            currentHealth.text = "Err"
        }
        currentName.text = entityData.groupA.first?.name
    }*/
    
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
    
    func previousEntity(){
        if currentPosition > 0 {
            currentPosition -= 1
        } else {
            currentPosition = entityData.groupA.count-1
        }
        setShowboxEntity(pos: currentPosition)
    }
    
    func nextEntity(){
        if currentPosition < entityData.groupA.count-1 {
            currentPosition += 1
        } else {
            currentPosition = 0
        }
        setShowboxEntity(pos: currentPosition)
    }
    
    @IBAction func previousButton(_ sender: Any) {
        previousEntity()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        nextEntity()
    }
    
    @IBAction func attackButton(_ sender: Any) {
        
    }
    
    @IBAction func healButton(_ sender: Any) {
        
    }
    
}



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
        setShowboxEntity(pos: 0)
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


// keep data persistant in array
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
        // print("to done")
        // dismiss(animated: true, completion: nil)
    }
    
    
}
