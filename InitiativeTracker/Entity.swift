//
//  Entity.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 24.03.23.
//

import Foundation

struct Entity {
    let name: String
    let health: Int
    let initiative: Int
    let isFriend: Bool
    let isAlive: Bool
    //TODO: implement a 'notes' variable
    
    // c-tor
    init(name: String, health: Int, initiative: Int, isFriend: Bool, isAlive: Bool){
        self.name = name
        self.health = health
        self.initiative = initiative
        self.isFriend = isFriend
        self.isAlive = isAlive
    }
    
    // Dead/Alive toggler [create copy of entity with inverted 'isAlive']
    func isAliveToggled() -> Entity {
        return Entity(name: name, health: health, initiative: initiative, isFriend: isFriend, isAlive: !isAlive)
    }
    
}


