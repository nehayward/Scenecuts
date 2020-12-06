//
//  AdvanceSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

struct SceneSettingsView: View {
    @ObservedObject var helper: Helper
    
    var body: some View {
        Form {
            VStack(spacing: 10) {
                HStack(alignment: .center, spacing: 0) {
                    Text(Localized.showInMenuBar)
                        .frame(width: 120)
                    Divider()
                    Text(Localized.sceneName)
                        .frame(width: 140)
                    Divider()
                    Text(Localized.menuBarIcon)
                        .frame(width: 120)
                    Divider()
                    Text(Localized.globalShortcut)
                        .frame(width: 160)
                }
                .frame(height: 30)
                .border(SeparatorShapeStyle())
                
                ScrollView {
                    ForEach(helper.scenes, id: \.self){ scene in
                        SceneConfigurationView(scene: scene)
                    }
                }.frame(minHeight: 400)
                
            }
        }
        .padding(.bottom, 20)
        .border(SeparatorShapeStyle())
    }
}

extension SceneSettingsView {
    enum Localized {
        static var showInMenuBar: String {
            .localizedStringWithFormat(NSLocalizedString("Show in Menu Bar", comment: "A column header that shows a list of toggles to show/hide scenes in menu bar."))
        }
        
        static var sceneName: String {
            .localizedStringWithFormat(NSLocalizedString("Name", comment: "A column header that shows a list of scene names."))
        }
        
        static var menuBarIcon: String {
            .localizedStringWithFormat(NSLocalizedString("Menu Bar Icon", comment: "A column header that shows a list of icon buttons to set an icon for the specific scene."))
        }
        
        static var globalShortcut: String {
            .localizedStringWithFormat(NSLocalizedString("Global Shortcut", comment: "A column header that shows a list of buttons to assign a global keyboard shortcut to the specific icon"))
        }
    }
}


struct SceneSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SceneSettingsView(helper: HelperManager.shared.helper)
    }
}
