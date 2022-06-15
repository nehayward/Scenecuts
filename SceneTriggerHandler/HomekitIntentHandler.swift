//
//  IntentHandler.swift
//  Handler
//
//  Created by Nick Hayward on 11/2/21.
//

import Intents
import UIKit

class HomekitIntentHandler: INExtension, ConfigurationIntentHandling {

    var scenesUpdated: (([WidgetInfo]) -> Void)?

    override init() {
        super.init()
        DistributedNotificationCenter.default.addObserver(self, selector: #selector(updateScenes), name: .widgetScenes, object: nil)
    }

    func provideHomekitSceneOptionsCollection(for intent: ConfigurationIntent, with completion: @escaping (INObjectCollection<HomeScene>?, Error?) -> Void) {
        scenesUpdated = { scenes in
            let homeScenes = scenes.map { (homescene) -> HomeScene in
                let eventCategory = HomeScene(identifier: homescene.id.uuidString, display: homescene.name)
                let image = UIImage(systemName: homescene.imageName)?.withTintColor(.systemBackground)
                let imageData = image?.pngData()
                eventCategory.displayImage = INImage(imageData: imageData!)
                eventCategory.iconName = homescene.imageName
                return eventCategory
            }
            let collection = INObjectCollection(items: homeScenes)
            DispatchQueue.main.async {
                completion(collection, nil)
            }
        }

        DistributedNotificationCenter.default().postNotificationName(.getScenes, object: nil, userInfo: nil, deliverImmediately: true)
    }

    @objc func updateScenes(_ notification: Notification) {
        guard let jsonEncodedString = notification.object as? String,
              let jsonEncoded = jsonEncodedString.removingPercentEncoding,
              let data = jsonEncoded.data(using: .utf8),
              let actionsSets = try? JSONDecoder().decode([WidgetInfo].self, from: data) else { return }

        scenesUpdated?(actionsSets)
    }

    override func handler(for intent: INIntent) -> Any? {
        return self
    }

    deinit {
        DistributedNotificationCenter.default.removeObserver(self, name: .widgetScenes, object: nil)
    }
}

enum HomeKitIntentHandlerError: Error {
    case failed
}
