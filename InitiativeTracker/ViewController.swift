//
//  ViewController.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 22.03.23.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let entityData = EntityData()
        entityData.load()
    }
    
    
    
    // MARK: Storyboard connections
    // move to storyboard 'Board'
    @IBAction func buttonToBoard(_ sender: UIButton){
        let storyboard = UIStoryboard(name: "Board", bundle: nil)
        let vc  = storyboard.instantiateInitialViewController()
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {return}
        windowScene.windows.first?.rootViewController = vc
    }
}

