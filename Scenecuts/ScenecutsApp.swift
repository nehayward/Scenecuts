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
        }.commands {
            CommandMenu("File") {
                Button(action: {
                    NSApp.mainWindow?.close()
                }) {
                    Text("Close")
                }.keyboardShortcut("w", modifiers: .command)
                Divider()
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    Text("Quit")
                }.keyboardShortcut("q", modifiers: .command)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // MARK: Have option to disable this in settings.
        StatusBarController.shared.openPreferences()

        // MARK: Ask for scenes from helper
        DistributedNotificationCenter.default().postNotificationName(.requestScenes, object: nil, userInfo: nil, deliverImmediately: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        NSApp.setActivationPolicy(.prohibited)
        return false
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        HelperManager.shared.terminateHelper()
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        StatusBarController.shared.openPreferences()
        return true
    }
}


