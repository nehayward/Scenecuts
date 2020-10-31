//
//  MenuBar.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import Foundation
import Cocoa
import SwiftUI

class StatusBarController {
    static var shared = StatusBarController()
    var statusItems: [UUID: NSStatusItem] = [:]
    
    private lazy var mainStatusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.button?.image = NSImage(systemSymbolName: "house.fill", accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
        statusItem.button?.target = self
        
        let menu = NSMenu()
        let menuItem = menu.addItem(withTitle: "Preferences...", action: #selector(openPreferences), keyEquivalent: ",")
        menuItem.target = self
        statusItem.menu = menu
        
        // MARK: Add separator
        menu.addItem(NSMenuItem.separator())
        
        let quitMenuItem = menu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitMenuItem.target = self
        
        return statusItem
    }()
    
    func createStatusItem(from scene: SceneStatusBarItem) -> NSStatusItem {
        let image = NSImage(systemSymbolName: scene.icon, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // MARK: Add Option to add Image
//        statusItem.button?.image = image
        statusItem.button?.title = scene.name
        statusItem.button?.identifier = NSUserInterfaceItemIdentifier(scene.id.uuidString)
        statusItem.button?.action = #selector(triggerAction)
        statusItem.button?.target = self
        return statusItem
    }
    
    init() {
        print(mainStatusItem)
    }

    @objc func openPreferences() {
        NSApp.setActivationPolicy(.regular)

        // MARK: This could probably be improved, currently a work around for showing preference window.
        guard let preferenceItem = NSApplication.shared.mainMenu?.items[0].submenu?.items[0] else { return }
        NSApp.sendAction(preferenceItem.action!, to: preferenceItem.target, from: preferenceItem)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    @objc func triggerAction(_ sender: NSStatusBarButton) {
        guard let identifier = sender.identifier?.rawValue,
              let uuid = UUID(uuidString: identifier),
              let id = HelperManager.shared.helper.scenes.first(where: { $0.id == uuid})?.id else { return }
        
        var components = URLComponents()
        components.scheme = "scenecutshelper"
        components.queryItems = [URLQueryItem(name: "uuid", value: id.uuidString)]
        
        NSWorkspace.shared.open(components.url!)
        #warning("Trigger Action, with URL")
    }
    
    func addMenuItem(for actionSet: ActionSet) {
        guard let menu = mainStatusItem.menu else { return }
        let menuItem = NSMenuItem(title: actionSet.name, action: #selector(triggerAction), keyEquivalent: "")
        menuItem.identifier = NSUserInterfaceItemIdentifier(actionSet.id.uuidString)
        menuItem.target = self
        
        // MARK: Don't add duplicates
        if menu.items.contains(where: { (item) -> Bool in
            item.identifier?.rawValue == actionSet.id.uuidString
        }) {
            return
        }
        menu.items.insert(menuItem, at: 0)
        
    }
}

class SceneStatusBarItem: Identifiable, Equatable {
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
