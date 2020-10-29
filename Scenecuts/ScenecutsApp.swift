//
//  ScenecutsApp.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

@main
struct ScenecutsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        Settings {
            SettingsView().onChange(of: scenePhase) { (newPhase) in
                print(newPhase)
            }.onExitCommand {
                print("exit")
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: StatusBarController!

    func applicationWillFinishLaunching(_ notification: Notification) {
        StatusBarController.shared.hello()
        
//        let runningApps = NSWorkspace.shared.runningApplications
//           let isRunning = runningApps.contains {
//               $0.bundleIdentifier == "your.domain.TestAutoLaunch"
//           }
//
//           if !isRunning {
//               var path = Bundle.main.bundlePath as NSString
//               for _ in 1...4 {
//                   path = path.deletingLastPathComponent as NSString
//               }
//               NSWorkspace.shared.launchApplication(path as String)
//           }
        
        let appURL = Bundle.main.url(forResource: "ScenecutsHelper", withExtension: "app")
        NSWorkspace.shared.openApplication(at: appURL!, configuration: NSWorkspace.OpenConfiguration()) { (running, error) in
            print(running)
            print(error)
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.prohibited)
        return false
    }
}


