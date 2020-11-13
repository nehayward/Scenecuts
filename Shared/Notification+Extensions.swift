//
//  Notification+Extensions.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/1/20.
//

import Foundation

extension NSNotification.Name {
    
    /// Trigger Scene with `message` containing UUIDs
    static let triggerScene = Self("TriggerScene")
    
    /// Update Scene with `message` containing an array of scene names and UUIDs
    static let updateScene = Self("UpdateScene")
    
    /// Request Scenes with `message` containing an array of scene names and UUIDs
    static let requestScenes = Self("RequestScenes")
    
    /// Terminate Helper app
    static let terminateHelper = Self("TerminateHelper")
}
