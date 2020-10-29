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
    var statusItems: [NSStatusItem] = []
    
    var sceneMenuBarItems: [SceneStatusBarItem] = [] {
        didSet {
            let showInMenuBar = sceneMenuBarItems.filter(\.showInMenuBar)
            print(showInMenuBar)
            
            statusItems.removeAll()
            showInMenuBar.forEach { (item) in
                let image = NSImage(systemSymbolName: item.icon, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
                let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
                statusItem.button?.image = image
                statusItem.button?.action = #selector(triggerAction)
                statusItem.button?.target = self
                statusItem.button?.title = "Hello"
                statusItems.append(statusItem)
            }
        }
    }
    
    private lazy var mainStatusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        statusItem.button?.image = NSImage(systemSymbolName: "house.fill", accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 16, weight: .regular))
        statusItem.button?.target = self
        
        return statusItem
    }()
    
    init() {
        let menu = NSMenu()
        let menuItem = menu.addItem(withTitle: "Preferences...", action: #selector(hello), keyEquivalent: ",")
        menuItem.target = self
        mainStatusItem.menu = menu
    }
    
    @objc func hello() {
        sceneMenuBarItems.append(SceneStatusBarItem(name: "Brandford", icon: "house", shortcut: "ab", showInMenuBar: false))
        NSApp.setActivationPolicy(.regular)

        // MARK: This could probably be improved, currently a work around for showing preference window.
        guard let preferenceItem = NSApplication.shared.mainMenu?.items[0].submenu?.items[0] else { return }
        NSApp.sendAction(preferenceItem.action!, to: preferenceItem.target, from: preferenceItem)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func triggerAction(_ sender: NSStatusBarButton) {
        print(sender.title)
        CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName("TriggerActionPlease" as CFString), nil, nil, true)
    }
}


struct SceneStatusBarItem: Hashable {
    let name: String
    let icon: String
    let shortcut: String
    var showInMenuBar: Bool
}
