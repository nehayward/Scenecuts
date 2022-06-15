//
//  RequestReviewManager.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/5/21.
//

import Foundation
import StoreKit

class RequestReviewManager {
    static var shared = RequestReviewManager()
    private var sceneTriggerCountKey = "SCSceneTriggerCount"
    
    private var sceneTriggerCount: Int {
        get {
            UserDefaults.standard.integer(forKey: sceneTriggerCountKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: sceneTriggerCountKey)
        }
    }

    func requestReview() {
        guard sceneTriggerCount >= 5 else {
            sceneTriggerCount += 1
            return
        }

        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}
