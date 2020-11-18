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
        
        statusItem.button?.image = NSImage(systemSymbolName: "homekit", accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
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
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // MARK: Add Option to add Image
        if !scene.iconName.isEmpty {
            let image = NSImage(systemSymbolName: scene.iconName, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
            statusItem.button?.image = image
        } else {
            statusItem.button?.title = scene.name
        }
        
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
        NSApp.mainWindow?.makeKeyAndOrderFront(nil)
        NSApp.sendAction(preferenceItem.action!, to: preferenceItem.target, from: preferenceItem)
    }
    
    @objc func quit() {
        NSApp.terminate(self)
    }
    
    @objc func triggerAction(_ sender: NSStatusBarButton) {
        guard let identifier = sender.identifier?.rawValue,
              let uuid = UUID(uuidString: identifier),
              let id = HelperManager.shared.helper.scenes.first(where: { $0.id == uuid})?.id else { return }
        
        DistributedNotificationCenter.default().postNotificationName(.triggerScene, object: id.uuidString, userInfo: nil, deliverImmediately: true)
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
    
    func removeMenuItem(with id: String) {
        guard let menu = mainStatusItem.menu else { return }
       
        menu.items.removeAll { (menuItem) -> Bool in
            menuItem.identifier?.rawValue == id
        }
    }
    
    func clearHomeKitScenes() {
        guard let menu = mainStatusItem.menu else { return }
        
        HelperManager.shared.helper.scenes.forEach { (scene) in
            menu.items.removeAll { (menu) -> Bool in
                menu.identifier?.rawValue == scene.id.uuidString
            }
        }
    }
}
