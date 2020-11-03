//
//  ActionSet.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/31/20.
//

import Foundation

struct ActionSet: Codable {
    let name: String
    let id: UUID
    
    internal init(name: String, id: UUID) {
        self.name = name
        self.id = id
    }
}
