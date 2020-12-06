//
//  SceneConfigurationView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 12/5/20.
//

import SwiftUI
import KeyboardShortcuts

struct SceneConfigurationView: View {
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
                        Image(systemName: "xmark.circle.fill")
                    }.buttonStyle(BorderlessButtonStyle())
                }
                Button {
                    showImageView.toggle()
                } label: {
                    if scene.iconName.isEmpty {
                        Text(Localized.setImage.localizedCapitalized)
                    } else {
                        Image(systemName: scene.iconName)
                    }
                }
            }
            .frame(width: 120)
            KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(scene.id.uuidString))
                .frame(width: 160)
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
                                                         isInMenuBar: false))
    }
}
