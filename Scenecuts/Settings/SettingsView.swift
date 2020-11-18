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
        case general, advanced, testing
    }
    
    var body: some View {
        TabView {
            GeneralSettingsView(helper: HelperManager.shared.helper)
                .frame(width: 600, height: 200)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            SceneSettingsView(helper: HelperManager.shared.helper)
                .frame(width: 600)
                .tabItem {
                    Label("Scenes", systemImage: "play.circle")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
        .frame(minWidth: 375)
    }
}

struct SettingsViewTest_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
