//
//  Icon.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/15/20.
//

import SwiftUI
import SFSafeSymbols

struct IconButton: View {
    @ObservedObject var scene: SceneStatusBarItem
    var symbol: SFSymbol
    
    var body: some View {
        Button {
            Task { @MainActor in
                scene.iconName = symbol.rawValue
            }
        } label: {
            VStack {
                Image(systemSymbol: symbol)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.primary)
                    .aspectRatio(contentMode: .fit)
                    .padding()

                Text(symbol.rawValue)
                    .foregroundColor(.primary)
            }
        }
        .buttonStyle(.plain)
        .frame(height: 180)
    }
}

//struct IconButton_Previews: PreviewProvider {
//    static var previews: some View {
//        IconButton(scene: SceneStatusBarItem(id: UUID(),
//                                             name: "TV",
//                                             iconName: "tv",
//                                             shortcut: "",
//                                             actionType: .userDefined,
//                                             isInMenuBar: false,
//                                             showInMenuList: true), symbol: .tv)
//    }
//}
