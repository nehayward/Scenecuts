//
//  UserDefaults+Preferences.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/28/20.
//

import Foundation

extension UserDefaults {
    private enum Keys: String {
        case hidePreferencesOnLaunch
    }
    
    // MARK: - HidePreferencesOnLaunch
    var hidePreferencesOnLaunch: Bool {
        set {
            set(newValue, forKey: UserDefaults.Keys.hidePreferencesOnLaunch.rawValue)
        }
        get {
            bool(forKey: UserDefaults.Keys.hidePreferencesOnLaunch.rawValue)
        }
    }
}
