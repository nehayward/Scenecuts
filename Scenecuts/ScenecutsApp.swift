//
//  ScenecutsApp.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI
import KeyboardShortcuts

@main
struct ScenecutsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            SettingsView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController!

    func applicationWillFinishLaunching(_ notification: Notification) {
        // MARK: Have option to disable this in settings.
        StatusBarController.shared.openPreferences()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.prohibited)
        return false
    }
  
    func application(_ application: NSApplication, open urls: [URL]) {
      
        urls.forEach { (url) in
            // Process the URL.
            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
                  let path = components.path,
                  let params = components.queryItems else {
                print("Invalid URL or path missing")
                return
            }
            
            print(path)
            if let commaSeparatedNames = params.first(where: { $0.name == "names" })?.value,
               let json = params.first(where: { $0.name == "json" })?.value {
                let names = commaSeparatedNames.components(separatedBy: ",")
                let data = json.removingPercentEncoding
                print(data)
                let actionsSets = try! JSONDecoder().decode([ActionSet].self, from: data!.data(using: .utf8)!)
                print(actionsSets)
                
                actionsSets.forEach { (actionSet) in
                    StatusBarController.shared.addMenuItem(for: actionSet)
                    let showInMenuBar = UserDefaults.standard.bool(forKey: actionSet.id.uuidString)
                    let scene = SceneStatusBarItem(id: actionSet.id, name: actionSet.name, icon: "tv", shortcut: "", isInMenuBar: showInMenuBar)
                    if !HelperManager.shared.helper.scenes.contains(scene) {
                        HelperManager.shared.helper.scenes.append(scene)
                    }
                    
                    if showInMenuBar {
                        StatusBarController.shared.statusItems[scene.id] = StatusBarController.shared.createStatusItem(from: scene)
                    }
                }
                return
            }
        }
    }
}


