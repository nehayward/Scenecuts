//
//  Icon.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/15/20.
//

import SwiftUI
import SFSafeSymbols

struct IconButton: View {
    var scene: SceneStatusBarItem
    var symbol: SFSymbol
    
    var body: some View {
        Button (action: {
            scene.iconName = symbol.rawValue
        }) {
            VStack {
                Image(systemSymbol: symbol)
                    .font(.title)
                Text(symbol.rawValue)
                    .font(.caption)
                    .minimumScaleFactor(0.005)
                    .lineLimit(1)
                    .frame(width: 50)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 50, height: 50)
    }
}

struct Icon_Previews: PreviewProvider {
    static var previews: some View {
        Icon(scene: SceneStatusBarItem(id: UUID(),
                                       name: "TV",
                                       iconName: "tv",
                                       shortcut: "",
                                       isInMenuBar: false), symbol: .tv)
    }
}
