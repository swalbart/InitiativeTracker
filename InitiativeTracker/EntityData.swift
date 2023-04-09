//
//  EntityData.swift
//  InitiativeTracker
//
//  Created by Tobias Zinke on 02.04.23.
//

import Foundation

class EntityData: Codable {
    static let shared = EntityData()

    var groupA: [Entity] = []
    
    
    
    // MARK: Save data
    // serializes EntityData with JSONencoder and saves it
    func save() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            try data.write(to: fileURL())
        } catch {
            print("Error saving entity data: (error.localizedDescription)")
        }
    }
    
    

    // MARK: Load data
    // loads EntityData and deserializes it with JSONdecoder
    func load() {
        do {
            let data = try Data(contentsOf: fileURL())
            let decoder = JSONDecoder()
            let loadedData = try decoder.decode(EntityData.self, from: data)
            self.groupA = loadedData.groupA
        } catch {
            print("Error loading entity data: (error.localizedDescription)")
        }
    }
    
    

    // MARK: Path for data
    private func fileURL() -> URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("entityData.json")
        return url
    }
}
