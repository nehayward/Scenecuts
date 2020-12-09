//
//  MenuBar.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import Foundation
import Cocoa
import SwiftUI
import SFSafeSymbols
import KeyboardShortcuts

class StatusBarController {
    static var shared = StatusBarController()
    var statusItems: [UUID: NSStatusItem] = [:]

    private lazy var mainStatusItem: NSStatusItem = {
        let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        statusItem.button?.image = NSImage(systemSymbol: SFSymbol.homekit, accessibilityDescription: nil)?.withSymbolConfiguration(.init(pointSize: 14, weight: .regular))
        statusItem.button?.target = self

        let menu = NSMenu()

        // MARK: Add separator
        menu.addItem(NSMenuItem.separator())

        let menuItem = menu.addItem(withTitle: "\(Localized.preferences.localizedCapitalized)…", action: #selector(openPreferences), keyEquivalent: ",")
        menuItem.target = self

        // MARK: Add separator
        let quitSeparator = NSMenuItem.separator()
        menu.addItem(quitSeparator)

        let quitMenuItem = menu.addItem(withTitle: "\(Localized.quit.localizedCapitalized)", action: #selector(quit), keyEquivalent: "q")
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

        // MARK: Workaround for frozen status bar - https://stackoverflow.com/questions/41340071/macos-menubar-application-main-menu-not-being-displayed
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

        var iconName: String = SceneStatusBarItem.value(id: actionSet.id, forKey: .iconName) ?? ""
        if iconName.isEmpty {
            iconName = actionSet.defaultSymbol.rawValue
        }
        let iconImage = NSImage(systemSymbolName: iconName, accessibilityDescription: nil)
        
        menuItem.image = iconImage?.withSymbolConfiguration(.init(pointSize: 13, weight: .regular))
        menuItem.toolTip = "\(Localized.triggerHomeKitScene) ”\(actionSet.name)”"

        // MARK: Don't add duplicates
        if menu.items.contains(where: { (item) -> Bool in
            item.identifier?.rawValue == actionSet.id.uuidString
        }) {
            return
        }
        menu.items.append(menuItem)
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
    
    func moveMenuItem(from: IndexSet, to: Int) {
        guard let menu = mainStatusItem.menu else { return }
        menu.items.move(fromOffsets: from, toOffset: to)
    }

    func updateMenuItemLocations() {
        guard let menu = mainStatusItem.menu else { return }

        let preferenceItemDivider = menu.indexOfItem(withTitle: "")
        menu.items.move(fromOffsets: IndexSet(preferenceItemDivider...preferenceItemDivider), toOffset: menu.items.count)
        
        let preferenceItem = menu.indexOfItem(withTitle: "\(Localized.preferences.localizedCapitalized)…")
        menu.items.move(fromOffsets: IndexSet(preferenceItem...preferenceItem), toOffset: menu.items.count)
        
        let quitItemDivider = menu.indexOfItem(withTitle: "")
        menu.items.move(fromOffsets: IndexSet(quitItemDivider...quitItemDivider), toOffset: menu.items.count)
        let quitItem = menu.indexOfItem(withTitle: Localized.quit.localizedCapitalized)
        menu.items.move(fromOffsets: IndexSet(quitItem...quitItem), toOffset: menu.items.count)
    }

    func updateMenuItems() {
        StatusBarController.shared.clearHomeKitScenes()
        HelperManager.shared.getScenes()
    }
}

extension StatusBarController {
    enum Localized {
        static var preferences: String {
            .localizedStringWithFormat(NSLocalizedString("Preferences", comment: "A button that opens preferences window"))
        }

        static var quit: String {
            .localizedStringWithFormat(NSLocalizedString("Quit", comment: "A button that quits the app."))
        }

        static var triggerHomeKitScene: String {
            .localizedStringWithFormat(NSLocalizedString("Trigger HomeKit scene", comment: "A message explaining the buttons action that will trigger/execute Homekit scene"))
        }
    }
}
