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
            // MARK: App Menu
            CommandGroup(after: CommandGroupPlacement.appInfo) {
                Button(action: {
                    NSApp.orderFrontStandardAboutPanel()
                }) {
                    Text("About Scenecuts")
                }
            }
            
            CommandGroup(after: CommandGroupPlacement.appTermination) {
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    Text("Quit")
                }.keyboardShortcut("q", modifiers: .command)
            }
            
            // MARK: Help Menu
            CommandGroup(after: CommandGroupPlacement.help) {
                Button(action: {
                    #warning("TODO: Add help local help book option")
//                    NSApp.showHelp(nil)
                    NSWorkspace.shared.open(URL(string: "https://nehayward.github.io/Scenecuts/pages/help")!)
                }) {
                    Text("Scenecuts Help")
                }
            }
            
            CommandMenu("File") {
                Button(action: {
                    NSApp.mainWindow?.close()
                }) {
                    Text("Close")
                }.keyboardShortcut("w", modifiers: .command)
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
        NSApp.setActivationPolicy(.accessory)
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


