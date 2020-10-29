//
//  SettingsViewTest.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

struct SettingsView: View {
    private enum Tabs: Hashable {
        case general, advanced
    }
    var body: some View {
        TabView {
            GeneralSettingsView()
                .frame(width: 375, height: 150)
                .tabItem {
                    Label("General", systemImage: "gear")
                }
                .tag(Tabs.general)
            
            AdvancedSettingsView()
                .frame(width: 375)
                .tabItem {
                    Label("Advanced", systemImage: "star")
                }
                .tag(Tabs.advanced)
        }
        .padding(20)
//        .frame(width: 375, height: 150)

    }
}


struct SettingsViewTest_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
