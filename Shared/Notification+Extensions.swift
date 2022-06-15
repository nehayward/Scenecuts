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
    
    /// Open Scenecuts
    static let openScenecuts = Self("OpenScenecuts")

    /// Request Scenes with `message`containing an array of scene names and UUIDs
    static let getScenes = Self("GetScenes")

    /// Request Scenes with `message`containing an array of scene names and UUIDs
    static let widgetScenes = Self("WidgetScenes")

    /// Request Scenes with `message`containing an array of scene names and UUIDs
    static let widgetTimelineScenes = Self("WidgetTimelineScenes")

    /// Request Scenes with `message`containing an array of scene names and UUIDs
    static let getScenesTimeline = Self("GetScenesTimeline")
}
