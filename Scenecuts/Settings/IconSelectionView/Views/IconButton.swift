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
                    .renderingMode(.template)
                    .foregroundColor(.primary)
                    .font(.system(size: 50))
                Text(symbol.rawValue)
                    .foregroundColor(.primary)
                    .font(.caption)
                    .minimumScaleFactor(0.005)
                    .lineLimit(1)
                    .frame(width: 50)
            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .frame(width: 80, height: 80)
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        IconButton(scene: SceneStatusBarItem(id: UUID(),
                                       name: "TV",
                                       iconName: "tv",
                                       shortcut: "",
                                       isInMenuBar: false,
                                       showInMenuList: true), symbol: .tv)
    }
}
