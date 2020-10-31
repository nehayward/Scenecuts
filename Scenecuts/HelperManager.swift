//
//  HelperManager.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import AppKit
import SwiftUI

class Helper: ObservableObject {
    @Published var helperAppIsRunning: Bool = false
//    @Published var scenes: [SceneStatusBarItem] = [SceneStatusBarItem(name: "Bradford", icon: "house", shortcut: "", isInMenuBar: false),
//                                                      SceneStatusBarItem(name: "TV Time", icon: "tv", shortcut: "", isInMenuBar: true)]
//
    @Published var scenes: [SceneStatusBarItem] = []

}



class HelperManager {
    static let shared = HelperManager()
    public let helper = Helper()
    
    init() {
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(printActive), name: NSWorkspace.didLaunchApplicationNotification, object: nil)
        
        NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(printActive), name: NSWorkspace.didDeactivateApplicationNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(fixPermission), name: NSNotification.Name("FixPermissions"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: NSNotification.Name("Scenes"), object: nil)
        addObserver()
        addObserverForScenes()
        
        
        print(helper.scenes)
        helper.scenes.forEach { (scene) in
            if scene.isInMenuBar {
                StatusBarController.shared.statusItems[scene.id] = StatusBarController.shared.createStatusItem(from: scene)
            } else {
                StatusBarController.shared.statusItems.removeValue(forKey: scene.id)
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//            HelperManager.shared.helper.scenes[0].name = "NOPE"
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
//            HelperManager.shared.helper.scenes[1].name = "5 Seconds"
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10)) {
//            HelperManager.shared.helper.scenes.removeLast()
//        }
    }
    
    @objc func printActive(_ notification: Notification) {
        print(notification)
        guard let userInfo = notification.userInfo as? [String: Any],
              let _ = userInfo["NSWorkspaceApplicationKey"] as? NSRunningApplication else { return }
        
//        print(NSWorkspace.shared.runningApplications)
        
        HelperManager.shared.helper.helperAppIsRunning = isActive()
    }
    
    func isActive() -> Bool {

        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == "com.nick.ScenecutsHelper"
        }
        return isRunning
    }
    
    func launchHelper() {
        if isActive() { return }
        
        
        let appURL = Bundle.main.url(forResource: "ScenecutsHelper", withExtension: "app")
        let configuration = NSWorkspace.OpenConfiguration()
        print(appURL)
        
        
        do
        {
          //  Find Application Support directory
          let fileManager = FileManager.default
            let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .allDomainsMask).first!
            
        print(appSupportURL)
//          //  Create subdirectory
//          let directoryURL = appSupportURL.appendingPathComponent("com.myCompany.myApp")
//          try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
//         //  Create document
//          let documentURL = directoryURL.appendingPathComponent ("MyFile.test")
//          try document.write (to: documentURL, ofType: "com.myCompany.test")
//            try FileManager.default.copyItem(at: appURL!, to: appSupportURL)
        }
        catch
        {
            print(error)
            print("An error occured")
        }
//
//
        NSWorkspace.shared.openApplication(at: appURL!, configuration: configuration) { (running, error) in
            print(running)
            print(error)
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
    
    func killHelper() {
        guard isActive() else { return }
        let runningApps = NSWorkspace.shared.runningApplications
        let helperApp = runningApps.first(where: { (runningApp) -> Bool in
            runningApp.bundleIdentifier == "com.nick.ScenecutsHelper"
        })
        helperApp?.terminate()
    }
    
    @objc func fixPermission() {
        let alert = NSAlert()
        alert.messageText = "Access Needed"
        alert.informativeText = "Home"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Open Privacy Settings")
        alert.addButton(withTitle: "Cancel")
        let buttonClicked = alert.runModal()
        
        if buttonClicked.rawValue == 1000  {
            let url = "x-apple.systempreferences:com.apple.preference.security?Privacy_HomeKit" // Update as needed
            NSWorkspace.shared.open(URL(string: url)!)
        }
    }
    
    @objc func updateScenes() {
        
    }
    
    func addObserver() {
        let center = CFNotificationCenterGetDarwinNotifyCenter()

        let callback: CFNotificationCallback = { (center, observer, name, object, userInfo) in
            NotificationCenter.default.post(name: Notification.Name(rawValue: "FixPermissions"), object: nil)
        }
        
        CFNotificationCenterAddObserver(center, nil, callback, "FixPermissions" as CFString, nil, .deliverImmediately)
    }
    
    func addObserverForScenes() {
        let center = CFNotificationCenterGetDarwinNotifyCenter()

        let callback: CFNotificationCallback = { (center, observer, name, object, userInfo) in
//            let names = userInfo["
            print(userInfo)
//            NotificationCenter.default.post(name: Notification.Name(rawValue: "Scenes"), object: nil, userInfo: ["scenes": names]
            NotificationCenter.default.post(name: Notification.Name(rawValue: "Scenes"), object: nil, userInfo: nil)
        }
        
        CFNotificationCenterAddObserver(center, nil, callback, "Scenes" as CFString, nil, .deliverImmediately)
    }
}
