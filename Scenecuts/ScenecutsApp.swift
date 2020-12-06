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
                    Text(Localized.aboutScenecuts.localizedCapitalized)
                }
            }
            
            CommandGroup(after: CommandGroupPlacement.appTermination) {
                Button(action: {
                    NSApp.terminate(nil)
                }) {
                    Text(Localized.quit.localizedCapitalized)
                }.keyboardShortcut("q", modifiers: .command)
            }
            
            // MARK: Help Menu
            CommandGroup(after: CommandGroupPlacement.help) {
                Button(action: {
                    #warning("TODO: Add help local help book option")
//                    NSApp.showHelp(nil)
                    NSWorkspace.shared.open(URL(string: "https://nehayward.github.io/Scenecuts/pages/help")!)
                }) {
                    Text(Localized.scenecutsHelp.localizedCapitalized)
                }
            }
            
            CommandMenu(Localized.file.localizedCapitalized) {
                Button(action: {
                    NSApp.mainWindow?.close()
                }) {
                    Text(Localized.close.localizedCapitalized)
                }.keyboardShortcut("w", modifiers: .command)
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if !UserDefaults.standard.hidePreferencesOnLaunch {
            StatusBarController.shared.openPreferences()
        }

        HelperManager.shared.getScenes()
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



extension ScenecutsApp {
    enum Localized {
        
        // MARK: Need to figure out how to translate CommandGroups or Open SwiftUI Scenes.
        static var preferences: String {
            .localizedStringWithFormat(NSLocalizedString("Preferences", comment: "A button that opens preferences window"))
        }
        
        static var quit: String {
            .localizedStringWithFormat(NSLocalizedString("Quit", comment: "A button that quits the app."))
        }
        
        static var aboutScenecuts: String {
            .localizedStringWithFormat(NSLocalizedString("About Scenecuts", comment: "A button that opens about screen of the app."))
        }
        
        static var scenecutsHelp: String {
            .localizedStringWithFormat(NSLocalizedString("Scenecuts Help", comment: "A button that opens up the help website."))
        }
        
        static var file: String {
            .localizedStringWithFormat(NSLocalizedString("File", comment: "A menu title for File, not sure if this is translated?"))
        }
        
        static var close: String {
            .localizedStringWithFormat(NSLocalizedString("Close", comment: "A file menu item to close top level window."))
        }
    }
}
