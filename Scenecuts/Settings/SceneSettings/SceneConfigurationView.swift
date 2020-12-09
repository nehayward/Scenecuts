//
//  SceneConfigurationView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 12/5/20.
//

import SwiftUI
import KeyboardShortcuts
import SFSafeSymbols

struct SceneConfigurationView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var scene: SceneStatusBarItem
    @State var showImageView = false

    var body: some View {
        HStack(spacing: 0) {
            Toggle("", isOn: $scene.isInMenuBar)
                .frame(width: 120)
            Text(scene.name)
                .frame(width: 140, alignment: .leading)
            HStack {
                if !scene.iconName.isEmpty {
                    Button {
                        scene.iconName = ""
                        if scene.isInMenuBar {
                            scene.isInMenuBar.toggle()
                            scene.isInMenuBar.toggle()
                        }
                    } label: {
                        Image(systemSymbol: .xmarkCircleFill)
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                    }.buttonStyle(BorderlessButtonStyle())
                }
                Button {
                    showImageView.toggle()
                } label: {
                    if scene.iconName.isEmpty {
                        Text(Localized.setImage.localizedCapitalized)
                            .foregroundColor(.primary)
                    } else {
                        Image(systemName: scene.iconName)
                            .renderingMode(.template)
                            .foregroundColor(.primary)
                    }
                }
            }
            .frame(width: 120)
            KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(scene.id.uuidString))
                .frame(width: 160)
            Toggle("", isOn: $scene.showInMenuList)
                .frame(width: 120)
        }.sheet(isPresented: $showImageView) {
            IconSelectionView(scene: scene, dismiss: $showImageView)
                .frame(width: 500, height: 400)
        }
    }
}

extension SceneConfigurationView {
    enum Localized {
        static var setImage: String {
            .localizedStringWithFormat(NSLocalizedString("Set Image", comment: "A button that opens a view to assign an icon/image to the scene."))
        }
    }
}

struct SceneConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        SceneConfigurationView(scene: SceneStatusBarItem(id: UUID(),
                                                         name: "",
                                                         iconName: "",
                                                         shortcut: "",
                                                         isInMenuBar: false,
                                                         showInMenuList: true))
    }
}
