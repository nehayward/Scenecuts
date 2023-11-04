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
    @ObservedObject var helper = HelperManager.shared.helper
    @State var window: NSWindow!

    init() {
        HelperManager.shared.launchHelper()
    }

    var body: some Scene {
//
//        MenuBarExtra {
//            VStack {
//                Button {
//                    showWindow()
//                } label: {
//                    HStack {
//                        Text("HERE")
//                    }
//                }
//                .keyboardShortcut("a")
//
//                Section("Scenes") {
//                    ForEach(helper.scenes) { scene in
//                        Button {
//                            print(scene.name)
//                            showWindow()
//                        } label: {
//                            HStack {
//                                Image(systemName: scene.iconName)
//                                Text(scene.name)
//                            }
//                        }
//                        .keyboardShortcut("a")
//                        .help("Quit")
//                    }
//                }
//                Divider()
//                Button("Quit") {
//                    NSApplication.shared.terminate(nil)
//                }.keyboardShortcut("q")
//            }
//        } label: {
//            Text("Hammer")
//                .background(.red)
//        }

        Settings {
            SettingsView()
        }.commands {
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
        .windowResizability(.contentMinSize)

    }

    private func showWindow() {
        // Close main app window
        let contentView = ScenePillView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 0),
            styleMask: [.borderless, .hudWindow],
            backing: .buffered, defer: false)

        let hostingView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.contentView = hostingView
        window.level = .floating
        window.isMovable = true
        window.isMovableByWindowBackground = true
        window.setPosition(vertical: .top, horizontal: .center)


//        window.backgroundColor = .clear

        window.animationBehavior = .alertPanel
        window.makeKeyAndOrderFront(self)

        let effect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        effect.blendingMode = .behindWindow
//        effect.state = .active
//        effect.material = .hudWindow
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 24
        window.contentView = effect
        window.contentView?.addSubview(hostingView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        window.isOpaque = false
        window.backgroundColor = .clear

        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.window.close()
            self.window.makeKeyAndOrderFront(nil)
            self.window.animator().alphaValue = 0
            self.window.close()
            self.window.resignKey()
            self.window = nil


        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.window.close()
            var position: [CGPoint] = []
            for window in NSApp.windows {
                print(window.frame.origin)
                print(window.isVisible)
                position.append(window.frame.origin)
            }
            self.window = self.createPillWindow()
            self.window.collectionBehavior = .stationary
            print(position)
            print(self.window.frame.origin)
//            self.window.makeKeyAndOrderFront(self)
            var current = self.window.contentView!.frame
            current.origin = position.first!
            var offset = self.window.contentView!.frame
            offset.origin = position.first!
            offset.origin.y = position.first!.y + 50
            offset.size = CGSize(width: 20, height: 20)
            self.window?.setFrame(offset, display: true, animate: true)
            self.window?.orderFront(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.window?.setFrame(current, display: true, animate: true)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                current.origin.y += 100
                current.size = .zero
                self.window?.setFrame(current, display: true, animate: true)
            }
        }


//        print(NSApplication.shared.men

//        window.alphaValue = 0
//        window.makeKeyAndOrderFront(nil)

    }

    func createPillWindow() -> NSWindow {
        let contentView = ScenePillView()

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 0),
            styleMask: [.borderless, .hudWindow],
            backing: .buffered, defer: false)

        let hostingView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.contentView = hostingView
        window.level = .floating
        window.isMovable = true
        window.isMovableByWindowBackground = true
        window.setPosition(vertical: .top, horizontal: .center)


//        window.backgroundColor = .clear


        let effect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        effect.blendingMode = .behindWindow
//        effect.state = .active
//        effect.material = .hudWindow
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 24
        window.contentView = effect
        window.contentView?.addSubview(hostingView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        window.isOpaque = false
        window.backgroundColor = .clear

        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)
        window.animationBehavior = .alertPanel

        return window
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ notification: Notification) {
//        showWindow()

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
    
    func applicationDidBecomeActive(_ notification: Notification) {
        print("Here")
    }

    private func showWindow() {
        // Close main app window
        let contentView = ScenePillView()

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 0),
            styleMask: [.borderless, .hudWindow],
            backing: .buffered, defer: false)

        let hostingView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.contentView = hostingView
        window.level = .floating
        window.isMovable = true
        window.isMovableByWindowBackground = true
        window.setPosition(vertical: .top, horizontal: .center)


//        window.backgroundColor = .clear

        window.animationBehavior = .alertPanel
        window.makeKeyAndOrderFront(self)

        let effect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        effect.blendingMode = .behindWindow
//        effect.state = .active
//        effect.material = .hudWindow
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 24
        window.contentView = effect
        window.contentView?.addSubview(hostingView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        window.isOpaque = false
        window.backgroundColor = .clear

        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.window.close()
            self.window.makeKeyAndOrderFront(nil)
            self.window.animator().alphaValue = 0
            self.window.close()
            self.window.resignKey()
            self.window = nil


        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.window.close()
            var position: [CGPoint] = []
            for window in NSApp.windows {
                print(window.frame.origin)
                print(window.isVisible)
                position.append(window.frame.origin)
            }
            self.window = self.createPillWindow()
            self.window.collectionBehavior = .stationary
            print(position)
            print(self.window.frame.origin)
//            self.window.makeKeyAndOrderFront(self)
            var current = self.window.contentView!.frame
            current.origin = position.first!
            var offset = self.window.contentView!.frame
            offset.origin = position.first!
            offset.origin.y = position.first!.y + 50
            offset.size = CGSize(width: 20, height: 20)
            self.window?.setFrame(offset, display: true, animate: true)
            self.window?.orderFront(nil)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.window?.setFrame(current, display: true, animate: true)
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                current.origin.y += 100
                current.size = .zero
                self.window?.setFrame(current, display: true, animate: true)
            }
        }


//        print(NSApplication.shared.men

//        window.alphaValue = 0
//        window.makeKeyAndOrderFront(nil)

    }

    func createPillWindow() -> NSWindow {
        let contentView = ScenePillView()

        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 200, height: 0),
            styleMask: [.borderless, .hudWindow],
            backing: .buffered, defer: false)

        let hostingView = NSHostingView(rootView: contentView)
        window.isReleasedWhenClosed = false
        window.contentView = hostingView
        window.level = .floating
        window.isMovable = true
        window.isMovableByWindowBackground = true
        window.setPosition(vertical: .top, horizontal: .center)


//        window.backgroundColor = .clear


        let effect = NSVisualEffectView(frame: NSRect(x: 0, y: 0, width: 0, height: 0))
        effect.blendingMode = .behindWindow
//        effect.state = .active
//        effect.material = .hudWindow
        effect.wantsLayer = true
        effect.layer?.cornerRadius = 24
        window.contentView = effect
        window.contentView?.addSubview(hostingView)
        window.titlebarAppearsTransparent = true
        window.titleVisibility = .hidden

        window.isOpaque = false
        window.backgroundColor = .clear

        window.titleVisibility = .hidden
        window.styleMask.remove(.titled)
        window.animationBehavior = .alertPanel

        return window
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
