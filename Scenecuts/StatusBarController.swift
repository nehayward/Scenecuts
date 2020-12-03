//
//  MenuBar.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import Foundation
import Cocoa
import SwiftUI
import KeyboardShortcuts

class StatusBarController {
    static var shared = StatusBarController()
    var statusItems: [UUID: NSStatusItem] = [:]
    
    private lazy var mainStatusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.button?.image = NSImage(systemSymbolName: "homekit", accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 14, weight: .regular))
        statusItem.button?.target = self
        
        let menu = NSMenu()
        
        // MARK: Add separator
        menu.addItem(NSMenuItem.separator())

        let menuItem = menu.addItem(withTitle: "Preferences…", action: #selector(openPreferences), keyEquivalent: ",")
        menuItem.target = self
        
        let quitMenuItem = menu.addItem(withTitle: "Quit", action: #selector(quit), keyEquivalent: "q")
        quitMenuItem.target = self
        
        statusItem.menu = menu
        return statusItem
    }()
    
    func createStatusItem(from scene: SceneStatusBarItem) -> NSStatusItem {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        // MARK: Add Option to add Image
        if !scene.iconName.isEmpty {
            let image = NSImage(systemSymbolName: scene.iconName, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 14, weight: .regular))
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
        // MARK: This could probably be improved, currently a work around for showing preference window.
        guard let preferenceItem = NSApp.mainMenu?.items[0].submenu?.items[2] else { return }
        NSApp.sendAction(preferenceItem.action!, to: nil, from: nil)
        
        // MARK: Workaround for frozen status bar- https://stackoverflow.com/questions/41340071/macos-menubar-application-main-menu-not-being-displayed
        NSApp.setActivationPolicy(.regular)
            NSApp.activate(ignoringOtherApps: true)
            NSApp.mainWindow?.makeKeyAndOrderFront(nil)

           if let isRunning = NSRunningApplication.runningApplications(withBundleIdentifier: "com.apple.dock").first?.activate(options: []),
              isRunning {
               let deadlineTime = DispatchTime.now() + .milliseconds(200)
               DispatchQueue.main.asyncAfter(deadline: deadlineTime) {
               NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
               }
           }
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
        menuItem.setShortcut(for: KeyboardShortcuts.Name(rawValue: actionSet.id.uuidString))
        
        let iconName: String = SceneStatusBarItem.value(id: actionSet.id, forKey: .iconName) ?? ""
        if !iconName.isEmpty {
            let image = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 13, weight: .regular))
            
            let menuAttributedTitle = NSMutableAttributedString(string: "\(actionSet.name) ")
            let iconAttachment = NSTextAttachment()
            iconAttachment.image = image
            menuAttributedTitle.append(NSAttributedString(attachment: iconAttachment))
            menuItem.attributedTitle = menuAttributedTitle
        }
        
        menuItem.toolTip = "Trigger HomeKit scene named \(actionSet.name)."
        
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
    
    func updateMenuItems() {
        StatusBarController.shared.clearHomeKitScenes()
        HelperManager.shared.getScenes()
    }
}
