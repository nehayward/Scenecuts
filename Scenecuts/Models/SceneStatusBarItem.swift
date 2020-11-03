//
//  File.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/3/20.
//

import Foundation

class SceneStatusBarItem: Identifiable, Equatable, Hashable, ObservableObject {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SceneStatusBarItem, rhs: SceneStatusBarItem) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(id: UUID = UUID(), name: String, icon: String, shortcut: String, isInMenuBar: Bool) {
        self.id = id
        self.name = name
        self.icon = icon
        self.shortcut = shortcut
        self.isInMenuBar = isInMenuBar
    }
    var id: UUID = UUID()
    let name: String
    let icon: String
    let shortcut: String
    
    
    
    @Published var isInMenuBar: Bool {
        didSet {
            UserDefaults.standard.setValue(isInMenuBar, forKey: self.id.uuidString)
            if isInMenuBar {
                StatusBarController.shared.statusItems[id] = StatusBarController.shared.createStatusItem(from: self)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: id)
            }
        }
    }
}
