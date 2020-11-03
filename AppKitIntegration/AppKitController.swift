//
//  AppKitController.swift
//  AppKitIntegration
//
//  Created by Steven Troughton-Smith on 29/09/2020.
//

import AppKit

extension NSWindow {
    @objc func ScenecutsHelper_makeKeyAndOrderFront(_ sender: Any) {
        NSLog("[NSWindow] No window for you!")
    }
}

@objc class AppKitController: NSObject {

    override init() {
        super.init()
        
        let m1 = class_getInstanceMethod(NSClassFromString("NSWindow"), NSSelectorFromString("makeKeyAndOrderFront:"))
        let m2 = class_getInstanceMethod(NSClassFromString("NSWindow"), NSSelectorFromString("ScenecutsHelper_makeKeyAndOrderFront:"))
        
        if let m1 = m1, let m2 = m2 {
            NSLog("Swizzling NSWindow")
            method_exchangeImplementations(m1, m2)
        }

        NSLog("[AppKitController] Loaded successfully")
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(triggerScene), name: .triggerScene, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(requestScenes), name: .requestScenes, object: nil)

    }
    
    @objc func triggerScene(_ notification: Notification) {
        guard let id = notification.object as? String else { return }
        NotificationCenter.default.post(name: .triggerScene, object: nil, userInfo: ["id": id])
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
    
    @objc func updateScenes(message: String) {
        DistributedNotificationCenter.default().postNotificationName(.updateScene, object: message, userInfo: nil, deliverImmediately: true)
    }
    
    @objc func requestScenes() {
        NotificationCenter.default.post(name: .requestScenes, object: nil)
    }
}
