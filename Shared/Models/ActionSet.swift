//
//  ActionSet.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/31/20.
//

import Foundation
import SFSafeSymbols

#if canImport(HomeKit)
import HomeKit
#endif

struct ActionSet: Codable {
    enum ActionType: String, Codable {
        case homeArrival
        case homeDeparture
        case sleep
        case wakeUp
        case userDefined
    }
    
    let name: String
    let id: UUID
    let type: ActionType
    
    #if canImport(HomeKit)
    internal init(name: String, id: UUID, type: String) {
        self.name = name
        self.id = id
        self.type = ActionType(type)
    }
    #endif
}

extension ActionSet {
    var defaultSymbol: SFSymbol {
        switch self.type {
        case .homeArrival:
            return .figureWalk
        case .homeDeparture:
            return .figureWave
        case .sleep:
            return .moonFill
        case .wakeUp:
            return .sunMaxFill
        case .userDefined:
            return .houseFill
        }
    }
}

#if canImport(HomeKit)
extension ActionSet.ActionType {
    internal init(_ rawValue: String) {
        switch rawValue {
        case HMActionSetTypeHomeArrival:
            self = .homeArrival
        case HMActionSetTypeHomeDeparture:
            self = .homeDeparture
        case HMActionSetTypeSleep:
            self = .sleep
        case HMActionSetTypeWakeUp:
            self = .wakeUp
        default:
            self = .userDefined
        }
    }
}
#endif
