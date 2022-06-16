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
        dateFormatter.locale = .current
        dateFormatter.doesRelativeDateFormatting = true
        dateFormatter.dateStyle = .medium
        return dateFormatter
    }()
    
    init() {
        addObservers()
        helper.scenes.forEach { (scene) in
            if scene.isInMenuBar {
                StatusBarController.shared.statusItems[scene.name] = StatusBarController.shared.createStatusItem(from: scene)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: scene.name)
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
        
        return "\(helperAppName)\n\(Localized.version) \(version)\n\(Localized.activeSince) \(dateFormatter.string(from: launchDate))"
    }
    
    func launchHelper() {
        if isActive() { return }
        let appURL = NSWorkspace.shared.urlForApplication(withBundleIdentifier: Self.helperAppName)
        let configuration = NSWorkspace.OpenConfiguration()
        
        NSWorkspace.shared.openApplication(at: appURL!, configuration: configuration) { (running, error) in
            if error != nil {
                DispatchQueue.main.async {
                    let alert = NSAlert()
                    alert.messageText = Localized.launchHelperAppErrorMessage.localizedCapitalized
                    alert.informativeText = Localized.helperAppError.localizedCapitalized
                    alert.alertStyle = .warning
                    alert.addButton(withTitle: Localized.launchHelperApp.localizedCapitalized)
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
            let showInMenuBar: Bool = SceneStatusBarItem.value(name: actionSet.name, forKey: .isInMenuBar) ?? false
            let iconName: String = SceneStatusBarItem.value(name: actionSet.name, forKey: .iconName) ?? ""
            let showInMenuList: Bool = SceneStatusBarItem.value(name: actionSet.name, forKey: .showInMenuList) ?? true

            let scene = SceneStatusBarItem(
                id: actionSet.id,
                name: actionSet.name,
                iconName: iconName,
                shortcut: "",
                actionType: actionSet.type,
                isInMenuBar: showInMenuBar,
                showInMenuList: showInMenuList
            )
            
            if !HelperManager.shared.helper.scenes.contains(scene) {
                HelperManager.shared.helper.scenes.append(scene)
                let name = KeyboardShortcuts.Name(rawValue: scene.name)!
                
                KeyboardShortcuts.onKeyUp(for: name) { [name] in
                    // MARK: Trigger scene for id.
                    let name = name.rawValue
                    guard let id = HelperManager.shared.helper.scenes.first(where: { $0.name == name})?.id.uuidString else { return }

                    DistributedNotificationCenter.default().postNotificationName(.triggerScene, object: id, userInfo: nil, deliverImmediately: true)
                }
            }
            
            if showInMenuBar {
                StatusBarController.shared.statusItems[scene.name] = StatusBarController.shared.createStatusItem(from: scene)
            }
            
            if showInMenuList {
                StatusBarController.shared.addMenuItem(for: actionSet)
            }
        }
        
        // MARK: Remove deleted actions
        let updatedIDs = actionsSets.map(\.name)
        let existingIDs = HelperManager.shared.helper.scenes.map(\.name)
        let idsToDelete = Array(Set(existingIDs).subtracting(Set(updatedIDs)))
        
        idsToDelete.forEach { (name) in
            StatusBarController.shared.removeMenuItem(with: name)
            
            for sequence in HelperManager.shared.helper.scenes.enumerated() {
                if sequence.element.name == name {
                    HelperManager.shared.helper.scenes.remove(at: sequence.offset)
                    let name = KeyboardShortcuts.Name(rawValue: sequence.element.name)!
                    KeyboardShortcuts.disable(name)
                    return
                }
            }
        }
        
        StatusBarController.shared.updateMenuItemLocations()
    }
    
    func addObservers() {
        // MARK: Needed to observe LSUIElement
        runningAppObservers =  NSWorkspace.shared.observe(\.runningApplications, options: [.initial, .new]) {(model, change) in
            // runningApplications changed, so update your UI or something else
            self.helper.helperAppIsRunning = self.isActive()
        }
        
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .updateScene, object: nil)
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(sendScenes), name: .getScenes, object: nil)
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(sendTimelineScenes), name: .getScenesTimeline, object: nil)
    }
    
    func getScenes() {
        // MARK: Ask for scenes from helper
        DistributedNotificationCenter.default().postNotificationName(.requestScenes, object: nil, userInfo: nil, deliverImmediately: true)
    }

    @objc func sendScenes() {
        let widgetInfo = helper.scenes.map { scene -> WidgetInfo in
            var iconName = scene.iconName
            if scene.iconName.isEmpty {
                iconName = scene.actionType.defaultSymbol.rawValue
            }
            return WidgetInfo(name: scene.name, id: scene.id, imageName: iconName)
        }

        guard let encoded = try? JSONEncoder().encode(widgetInfo),
              let jsonString = String(data: encoded, encoding: .utf8) else { return }

        DistributedNotificationCenter.default().postNotificationName(.widgetScenes, object: jsonString, userInfo: nil, deliverImmediately: true)
    }

    @objc func sendTimelineScenes() {
        let widgetInfo = helper.scenes.map { scene -> WidgetInfo in
            var iconName = scene.iconName
            if scene.iconName.isEmpty {
                iconName = scene.actionType.defaultSymbol.rawValue
            }
            return WidgetInfo(name: scene.name, id: scene.id, imageName: iconName)
        }

        guard let encoded = try? JSONEncoder().encode(widgetInfo),
              let jsonString = String(data: encoded, encoding: .utf8) else { return }

        DistributedNotificationCenter.default().postNotificationName(.widgetTimelineScenes, object: jsonString, userInfo: nil, deliverImmediately: true)
    }
}

extension HelperManager {
    enum Localized {
        static var activeSince: String {
            .localizedStringWithFormat(NSLocalizedString("Active Since", comment: "A date indicating how long the app has been active"))
        }
        
        static var version: String {
            .localizedStringWithFormat(NSLocalizedString("Version", comment: "Current version number"))
        }
        
        static var helperAppError: String {
            .localizedStringWithFormat(NSLocalizedString("Helper App Error", comment: "A header for error message"))
        }
        
        static var launchHelperApp: String {
            .localizedStringWithFormat(NSLocalizedString("Launch Helper App", comment: "A button to launch helper app."))
        }
        
        static var launchHelperAppErrorMessage: String {
            .localizedStringWithFormat(NSLocalizedString("Can't Open Helper App", comment: "A message explaining helper app wasn't launched."))
        }
    }
}
