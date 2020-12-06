//
//  SettingsViewTest.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, scenes, advanced
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView(helper: HelperManager.shared.helper)
                .frame(width: 600, height: 200)
                .tabItem {
                    Label(Localized.general.localizedCapitalized, systemImage: "gear")
                }
                .tag(Tabs.general)
            
            SceneSettingsView(helper: HelperManager.shared.helper)
                .frame(width: 600)
                .tabItem {
                    Label(Localized.scenes.localizedCapitalized, systemImage: "play.circle")
                }
                .tag(Tabs.scenes)
            
            AdvancedSettingsView()
                .frame(width: 600)
                .tabItem {
                    Label(Localized.advanced.localizedCapitalized, systemImage: "cpu")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(minWidth: 375)
    }
}

extension SettingsView {
    enum Localized {
        static var general: String {
            .localizedStringWithFormat(NSLocalizedString("General", comment: "A settings tab for all general settings"))
        }
        
        static var scenes: String {
            .localizedStringWithFormat(NSLocalizedString("Scenes", comment: "A tab for all scenes settings"))
        }
        
        static var advanced: String {
            .localizedStringWithFormat(NSLocalizedString("Advanced", comment: "A tab for all advanced settings"))
        }
    }
}

struct SettingsViewTest_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
