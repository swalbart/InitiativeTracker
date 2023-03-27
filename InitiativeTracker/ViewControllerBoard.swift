//
//  ViewControllerBoard.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 22.03.23.
//

import UIKit

class ViewControllerBoard: UIViewController{
    
    var entities = [
        Entity(name: "BBEG", health: 100, initiative: 18, isFriend: false),
        Entity(name: "Hero", health: 35, initiative: 16, isFriend: true),
        Entity(name: "NPC", health: 28, initiative: 9, isFriend: true),
    ]

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad(){
        super.viewDidLoad()
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
    
}



// Delegate
extension ViewControllerBoard: UITableViewDelegate{
    // swipe right behaviour of cells
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // swipe message and actions
        // style: .normal = gray color
        let action = UIContextualAction(style: .normal, title: "Toggle death"){ action, view, complete in
            // replace entity by a new entity with toggeled 'isAlive'-value
            let entity = self.entities[indexPath.row].isAliveToggled()
            self.entities[indexPath.row] = entity
            
            //update 'isAlive'-value to cell
            let cell = tableView.cellForRow(at: indexPath) as! CustomTableViewCell
            cell.set(isAlive: entity.isAlive)
            
            // reset swipe animation
            complete(true)
            print("toggeled 'isAlive'-value of entity")
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
        return entities.count
    }
    
    // apply entity values to display in cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.delegate = self
        // selection of the next entity
        let entity = entities[indexPath.row]
        // setting entityvalues to cell
        cell.set(name: entity.name, health: entity.health, initiative: entity.initiative, isAlive: entity.isAlive)
        return cell
    }
    
    // delete entity in entities-array and cell in tableview
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            entities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // reodering cells
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // remove cell from current spot
        let entity = entities.remove(at: sourceIndexPath.row)
        // insert cell in new spot
        entities.insert(entity, at: destinationIndexPath.row)
    }
}




extension ViewControllerBoard: CustomTableViewCellDelegate{
    func customTableViewCell(_ cell: CustomTableViewCell, didChangeIsAlive isAlive: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else{
            return
        }
        let entity = entities[indexPath.row]
        let newEntity = Entity(name: entity.name, health: entity.health, initiative: entity.initiative, isFriend: entity.isFriend)
        entities[indexPath.row] = newEntity
    }
}
