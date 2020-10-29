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
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.prohibited)
        return false
    }
}


