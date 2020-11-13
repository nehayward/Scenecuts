//
//  File.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/3/20.
//

import Foundation

class SceneStatusBarItem: Identifiable, Equatable, Hashable, ObservableObject {
    
    var id: UUID = UUID()
    let name: String
    let shortcut: String
    @Published var iconName: String {
        didSet {
            store(value: iconName, forKey: .iconName)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: SceneStatusBarItem, rhs: SceneStatusBarItem) -> Bool {
        lhs.id == rhs.id
    }
    
    internal init(id: UUID = UUID(), name: String, iconName: String, shortcut: String, isInMenuBar: Bool) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.shortcut = shortcut
        self.isInMenuBar = isInMenuBar
    }
    
    @Published var isInMenuBar: Bool {
        didSet {
            store(value: isInMenuBar, forKey: .isInMenuBar)
            if isInMenuBar {
                StatusBarController.shared.statusItems[id] = StatusBarController.shared.createStatusItem(from: self)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: id)
            }
        }
    }
}

extension SceneStatusBarItem {
    func store<T>(value: T, forKey key: Keys) {
        UserDefaults.standard.setValue(value, forKey: "\(id.uuidString).\(key.rawValue)")
    }
    
    static func value<T>(id: UUID, forKey key: Keys) -> T? {
        UserDefaults.standard.value(forKey: "\(id.uuidString).\(key.rawValue)") as? T
    }
    
    enum Keys: String {
        case iconName
        case isInMenuBar
    }
}
