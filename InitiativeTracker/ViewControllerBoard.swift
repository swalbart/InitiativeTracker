//
//  ViewControllerBoard.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 22.03.23.
//

import UIKit

class ViewControllerBoard: UIViewController{
    
    
    @IBOutlet weak var table: UITableView!
    /*
    override func viewDidLoad(){
        super.viewDidLoad()
        //
        table.register(UITableView.self, forCellReuseIdentifier: "cell")
        table.delegate = self
        table.dataSource = self
    }*/
    
    // move to storyboard "Main"
    @IBAction func buttonToMain(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc  = storyboard.instantiateInitialViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        windowScene.windows.first?.rootViewController = vc
    }
}

extension ViewControllerBoard: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellOne", for: indexPath) as! CustomTableViewCell
        cell.configure(text: "Custom Cell")
        //cell.textLabel?.text = "one"
        return cell
    }
}
