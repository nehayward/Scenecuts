//
//  Home.swift
//  AirQualityMonitor
//
//  Created by Steven Troughton-Smith on 06/10/2020.
//

import HomeKit

class Home: NSObject, HMHomeManagerDelegate, HMAccessoryDelegate {
    static let shared = Home()
    
    let homeManager = HMHomeManager()
    var window: UIWindow?
    
    func setup() {
        
    }
    
    override init() {
        super.init()
        homeManager.delegate = self
        
        if homeManager.authorizationStatus == .determined {
            CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFNotificationName("FixPermissions" as CFString), nil, nil, true)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(turnOnTV), name: NSNotification.Name("TurnOnTV"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(triggerScene), name: NSNotification.Name("TriggerScene"), object: nil)

        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {

            self.homeManager.primaryHome?.actionSets.forEach({ (action) in
                print(action.name)
                print(action.actionSetType)
                print(action.uniqueIdentifier)
                print(action.isExecuting)
            })
            
        
            guard let actionSets = self.homeManager.primaryHome?.actionSets else { return }
            
            let names = actionSets.map(\.name)
            let actions = actionSets.map {
                ActionSet(name: $0.name, id: $0.uniqueIdentifier)
            }
            
            let encoded = try! JSONEncoder().encode(actions)
            let jsonString = String(data: encoded, encoding: .utf8)!
            print(jsonString)
            let encodedString = jsonString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
            print(encodedString)
            var urlComponents = URLComponents()
            urlComponents.scheme = "scenecuts"
            urlComponents.path = "scenes"
            urlComponents.queryItems = [URLQueryItem(name: "names", value: names.joined(separator: ",")),
                                        URLQueryItem(name: "json", value: encodedString)]
            
            if let url = urlComponents.url {
                UIApplication.shared.open(url) { (success) in
                    print(success)
                }
            }
        }
        
        let center = CFNotificationCenterGetDarwinNotifyCenter()
        CFNotificationCenterAddObserver(center, Unmanaged.passRetained(self).toOpaque(), { (center, observer, name, object, userInfo) in
            print("GOT it")
        }, "TriggerActionPlease" as CFString, nil, .deliverImmediately)

        

    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        
        for accessory in homeManager.primaryHome!.accessories {
            accessory.delegate = self
            
            for service in accessory.services {
                queryAirQualityService(service)
            }
        }
    }
    
    @objc func turnOnTV() {
        guard let action = homeManager.primaryHome?.actionSets.first(where: { (action) -> Bool in
            action.name == "Video Games"
        }) else { return }
        
        homeManager.primaryHome?.executeActionSet(action, completionHandler: { (error) in
            print(error)
        })
    }
    
    @objc func triggerScene(_ notification: Notification) {
        guard let name = notification.userInfo?["name"] as? String else { return }
        
        guard let action = homeManager.primaryHome?.actionSets.first(where: { (action) -> Bool in
            action.name == name
        }) else { return }
        
        homeManager.primaryHome?.executeActionSet(action, completionHandler: { (error) in
            print(error)
            guard let error = error as? NSError else { return }
            
            if error.code == 25 {
                self.homeManager.primaryHome?.removeActionSet(action, completionHandler: { (error) in
                    print(error)
                })
            }
        })
    }
    
    func executeAction(with id: String) {
        guard let actionUUID = UUID(uuidString: id),
              let action = homeManager.primaryHome?.actionSets.first(where: { (action) -> Bool in
            action.uniqueIdentifier == actionUUID
        }) else { return }
        
        homeManager.primaryHome?.executeActionSet(action, completionHandler: { (error) in
            print(error)
            guard let error = error as? NSError else { return }
            
            if error.code == 25 {
                self.homeManager.primaryHome?.removeActionSet(action, completionHandler: { (error) in
                    print(error)
                })
            }
        })
    }
    
    @objc func showView() {
        UIApplication.shared.connectedScenes.forEach({ (scene) in
            print(scene.title)
        })
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: NSUserActivity(activityType: "ab"), options: nil, errorHandler: nil)
    }
    
//    func renderAirQuality() -> UIImage {
//        let size = CGSize(width: (6 * 21) + 8, height: 21)
//
//        let renderer = UIGraphicsImageRenderer(size: size)
//        let symcfg = UIImage.SymbolConfiguration(pointSize: 13, weight: .regular)
//
//        let image = renderer.image { (UIGraphicsImageRendererContext) in
//            for i in 0..<6 {
//
//                var glyph = UIImage(systemName: "leaf", withConfiguration: symcfg)?.withRenderingMode(.alwaysTemplate).withHorizontallyFlippedOrientation()
//
//                if i > 0 {
//                    glyph = UIImage(systemName: "star.fill", withConfiguration: symcfg)?.withRenderingMode(.alwaysTemplate)
//                }
//
//                if i > quality {
//                    glyph = UIImage(systemName: "star", withConfiguration: symcfg)?.withRenderingMode(.alwaysTemplate)
//                }
//
//                glyph?.draw(at: CGPoint(x: (i > 0 ? 8 : 0) + i * 21, y: (i == 0) ? 4 : 2))
//            }
//        }
//
//        return image.withRenderingMode(.alwaysTemplate)
//    }
    
    func queryAirQualityService(_ service : HMService) {
        print(homeManager.primaryHome?.actionSets)
        if !(homeManager.primaryHome?.actionSets.isEmpty ?? true) {
            let data = UIImage(systemName: "house.fill")?.pngData()
            if let data = data {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AirQuality"), object: nil, userInfo: ["data" : data])
            }
        }
        print(service, service.serviceType)
        if service.serviceType == HMServiceTypeAirQualitySensor {
            
            for characteristic in service.characteristics {
                
                switch characteristic.characteristicType {
                case HMCharacteristicTypeAirQuality:
                    characteristic.readValue { error in
                        
                        let number = characteristic.value as! NSNumber
                        
                        let value = HMCharacteristicValueAirQuality(rawValue: number.intValue)
                        print(value)
                        
//                        let image = self.renderAirQuality()
//                        let data = image.pngData()
//                        if let data = data {
//                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AirQuality"), object: nil, userInfo: ["data" : data])
//                        }
                    }
                    break
                default:
                    break
                }
                
            }
        }
    }
    
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
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        queryAirQualityService(service)
    }

    
    
}
