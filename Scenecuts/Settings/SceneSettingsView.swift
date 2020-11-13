//
//  AdvanceSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI
import KeyboardShortcuts

struct SceneSettingsView: View {
    @ObservedObject var helper: Helper
    
    var body: some View {
        Form {
            VStack(spacing: 10) {
                HStack(alignment: .center, spacing: 0) {
                    Text("Show in Menu Bar")
                        .frame(width: 120)
                    Divider()
                    Text("Name")
                        .frame(width: 140)
                    Divider()
                    Text("Image")
                        .frame(width: 120)
                    Divider()
                    Text("Global Shortcut")
                        .frame(width: 160)
                }
                .frame(height: 30)
                .border(SeparatorShapeStyle())
                
                
                ForEach(helper.scenes, id: \.self){ scene in
                    SceneConfigurationView(scene: scene)
                }
                
            }
        }
        .padding(.bottom, 20)
        .border(SeparatorShapeStyle())
    }
}


struct SceneConfigurationView: View {
    @ObservedObject var scene: SceneStatusBarItem
    @State var showImageView = false

    var body: some View {
        HStack(spacing: 0) {
            Toggle("", isOn: $scene.isInMenuBar)
                .frame(width: 120)
            Text(scene.name)
                .frame(width: 140, alignment: .leading)
            Button {
                showImageView.toggle()
            } label: {
                if scene.iconName.isEmpty {
                    Text("Set Image")
                } else {
                    Image(systemName: scene.iconName)
                }
            }
            .frame(width: 120)
            KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(scene.id.uuidString))
                .frame(width: 160)
        }.sheet(isPresented: $showImageView) {
            IconSelectionView(scene: scene, dismiss: $showImageView)
                .frame(width: 400, height: 400)
        }
    }
}


struct SceneSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SceneSettingsView(helper: HelperManager.shared.helper)
    }
}
