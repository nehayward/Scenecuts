//
//  Home.swift
//  AirQualityMonitor
//
//  Created by Steven Troughton-Smith on 06/10/2020.
//

import HomeKit

class Home: NSObject {
    static let shared = Home()
    
    let homeManager = HMHomeManager()
    
    func setup() {
        NotificationCenter.default.addObserver(self, selector: #selector(triggerScene), name: .triggerScene, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sendScene), name: .requestScenes, object: nil)
    }
    
    override init() {
        super.init()
        homeManager.delegate = self
        
        if homeManager.authorizationStatus == .determined {
            let fixPermissionSelector : Selector = NSSelectorFromString("fixPermission")
            AppDelegate.appKitController?.performSelector(onMainThread: fixPermissionSelector, with: nil, waitUntilDone: false)
            return
        }
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        homeManager.primaryHome?.delegate = self

        for accessory in homeManager.primaryHome!.accessories {
            accessory.delegate = self
        }
        
        // MARK: Update Scenes if needed
        sendScene()
    }
    
    
    @objc func triggerScene(_ notification: Notification) {
        guard let id = notification.userInfo?["id"] as? String else { return }
        
        guard let actionUUID = UUID(uuidString: id),
              let action = homeManager.primaryHome?.actionSets.first(where: { (action) -> Bool in
                action.uniqueIdentifier == actionUUID
              }) else { return }
        
        homeManager.primaryHome?.executeActionSet(action, completionHandler: { (error) in
            guard let error = error as NSError? else { return }
            
            // MARK: Action doesn't exist anymore.
            if error.code == 25 {
                self.homeManager.primaryHome?.removeActionSet(action, completionHandler: { (error) in
                    if let error = error as NSError? {
                        print(error)
                    }
                })
            }
        })
    }
    
    @objc func sendScene() {
        guard let actionSets = self.homeManager.primaryHome?.actionSets else { return }
        
        let actions = actionSets.map {
            ActionSet(name: $0.name, id: $0.uniqueIdentifier)
        }
        
        guard let encoded = try? JSONEncoder().encode(actions),
              let jsonString = String(data: encoded, encoding: .utf8) else { return }
        
        let encodedString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let updateSceneSelector = NSSelectorFromString("updateScenesWithMessage:")
        AppDelegate.appKitController?.performSelector(onMainThread: updateSceneSelector, with: encodedString, waitUntilDone: false)
    }
}

extension Home: HMHomeManagerDelegate {
    // MARK: - Delegate Methods
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        switch status {
        case .authorized:
            NSLog("[HOMEKIT STATUS] Authorized")
        case .determined:
            NSLog("[HOMEKIT STATUS] Determined")
        case .restricted:
            NSLog("[HOMEKIT STATUS] Restricted")
        default:
            break
        }
    }
    
}

extension Home: HMAccessoryDelegate {
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        #warning("Add Support for Accessories")
    }
}

extension Home: HMHomeDelegate {
    func home(_ home: HMHome, didRemove actionSet: HMActionSet) {
        // MARK: ActionSet Removed
        sendScene()
    }
    
    func home(_ home: HMHome, didAdd actionSet: HMActionSet) {
        sendScene()
    }
    
    func home(_ home: HMHome, didUpdateActionsFor actionSet: HMActionSet) {
        print(actionSet)
    }
    
    func home(_ home: HMHome, didUpdateNameFor actionSet: HMActionSet) {
        print(actionSet)
    }
}
