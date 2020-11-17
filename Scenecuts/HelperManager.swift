//
//  HelperManager.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import AppKit
import SwiftUI
import KeyboardShortcuts

class Helper: ObservableObject {
    @Published var helperAppIsRunning: Bool = false
    @Published var scenes: [SceneStatusBarItem] = []
}

class HelperManager {
    static let helperAppName = "com.nick.ScenecutsHelper"
    static let shared = HelperManager()
    public let helper = Helper()
    var runningAppObservers: NSKeyValueObservation?
    
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    init() {
        addObservers()
        
        helper.scenes.forEach { (scene) in
            if scene.isInMenuBar {
                StatusBarController.shared.statusItems[scene.id] = StatusBarController.shared.createStatusItem(from: scene)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: scene.id)
            }
        }
    }
    
    func isActive() -> Bool {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Self.helperAppName
        }
        return isRunning
    }
    
    var helperAppInformation: String {
        let runningApps = NSWorkspace.shared.runningApplications
        
        guard let helperApp = runningApps.first(where: {
            $0.bundleIdentifier == Self.helperAppName
        }) else { return "" }

        guard let bundleURL = helperApp.bundleURL,
              let bundle = Bundle(url: bundleURL),
              let launchDate = helperApp.launchDate,
              let infoDictionary = bundle.infoDictionary,
              let helperAppName = infoDictionary["CFBundleDisplayName"],
              let version = infoDictionary["CFBundleShortVersionString"] else { return "Scenecuts Helper\nVersion ?\nActive Since ?" }
        
        return "\(helperAppName)\nVersion \(version)\nActive Since \(dateFormatter.string(from: launchDate))"
    }
    
    func launchHelper() {
        if isActive() { return }
        let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: Self.helperAppName)
        let configuration = NSWorkspace.OpenConfiguration()
        
        NSWorkspace.shared.openApplication(at: appURL!, configuration: configuration) { (running, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = "Can't Open Helper App"
                    alert.informativeText = "Home"
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: "Launch Helper App")
                    let buttonClicked = alert.runModal()
                    
                    if buttonClicked.rawValue > 0 {
                        NSWorkspace.shared.open(appURL!.deletingLastPathComponent())
                    }
                }
                
            }
        }
    }
    
    func terminateHelper() {
        guard isActive() else { return }
        DistributedNotificationCenter.default().postNotificationName(.terminateHelper, object: nil, userInfo: nil, options: .deliverImmediately)
        StatusBarController.shared.clearHomeKitScenes()
        helper.scenes.removeAll()
    }
    
    @objc func updateScenes(_ notification: Notification) {
        guard let jsonEncodedString = notification.object as? String,
              let jsonEncoded = jsonEncodedString.removingPercentEncoding,
              let data = jsonEncoded.data(using: .utf8),
              let actionsSets = try? JSONDecoder().decode([ActionSet].self, from: data) else { return }
        
        actionsSets.forEach { (actionSet) in
            StatusBarController.shared.addMenuItem(for: actionSet)
            
            let showInMenuBar: Bool = SceneStatusBarItem.value(id: actionSet.id, forKey: .isInMenuBar) ?? false
            let iconName: String = SceneStatusBarItem.value(id: actionSet.id, forKey: .iconName) ?? ""
            
            let scene = SceneStatusBarItem(id: actionSet.id, name: actionSet.name, iconName: iconName, shortcut: "", isInMenuBar: showInMenuBar)
            if !HelperManager.shared.helper.scenes.contains(scene) {
                HelperManager.shared.helper.scenes.append(scene)
                let name = KeyboardShortcuts.Name(rawValue: scene.id.uuidString)!
                
                KeyboardShortcuts.onKeyUp(for: name) { [name] in
                    // The user pressed the keyboard shortcut for “unicorn mode”!
                    let id = name.rawValue
                    DistributedNotificationCenter.default().postNotificationName(.triggerScene, object: id, userInfo: nil, deliverImmediately: true)
                }
            }
            
            if showInMenuBar {
                StatusBarController.shared.statusItems[scene.id] = StatusBarController.shared.createStatusItem(from: scene)
            }
        }
        
        // MARK: Remove deleted actions
        let updatedIDs = actionsSets.map(\.id.uuidString)
        let existingIDs = HelperManager.shared.helper.scenes.map(\.id.uuidString)
        let idsToDelete = Array(Set(existingIDs).subtracting(Set(updatedIDs)))
        
        idsToDelete.forEach { (id) in
            StatusBarController.shared.removeMenuItem(with: id)
            
            for sequence in HelperManager.shared.helper.scenes.enumerated() {
                if sequence.element.id.uuidString == id {
                    HelperManager.shared.helper.scenes.remove(at: sequence.offset)
                    let name = KeyboardShortcuts.Name(rawValue: sequence.element.id.uuidString)!
                    KeyboardShortcuts.disable(name)
                    return
                }
            }
        }
    }
    
    func addObservers() {
        // MARK: Needed to observe LSUIElement
        runningAppObservers =  NSWorkspace.shared.observe(\.runningApplications, options: [.initial, .new]) {(model, change) in
            // runningApplications changed, so update your UI or something else
            self.helper.helperAppIsRunning = self.isActive()
        }
        
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .updateScene, object: nil)
    }
}
