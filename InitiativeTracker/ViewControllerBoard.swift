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
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        //table.delegate = self
        //table.dataSource = self
    }
    
    // move to storyboard "Main"
    @IBAction func buttonToMain(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateInitialViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        windowScene.windows.first?.rootViewController = vc
    }
}

// swipe behaviour of cells
extension ViewControllerBoard: UITableViewDelegate{
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
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
}

extension ViewControllerBoard: UITableViewDataSource{
    
    // amount of sections in tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // amount of cells in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        // selection of the next entity
        let entity = entities[indexPath.row]
        // setting entityvalues to cell
        cell.set(name: entity.name, health: entity.health, initiative: entity.initiative, isAlive: entity.isAlive)
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        // delete entity in entities-array and cell in tableview
        if editingStyle == .delete{
            entities.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
