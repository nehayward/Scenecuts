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

    @State var size: Double = 375

    var body: some View {
        TabView {
            GeneralSettingsView(helper: HelperManager.shared.helper)
                .tabItem {
                    Label(Localized.general.localizedCapitalized, systemImage: "gear")
                }
                .tag(Tabs.general)
                .onAppear {
                    size = 375
                }

            SceneSettingsView(helper: HelperManager.shared.helper)
                .tabItem {
                    Label(Localized.scenes.localizedCapitalized, systemImage: "gearshape.arrow.triangle.2.circlepath")
                }
                .tag(Tabs.scenes)
                .onAppear {
                    size = 800
                }

            AdvancedSettingsView()
                .tabItem {
                    Label(Localized.advanced.localizedCapitalized, systemImage: "cpu")
                }
                .tag(Tabs.advanced)
                .padding()
                .onAppear {
                    size = 375
                }
        }
        .frame(minWidth: size)
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

#Preview {
    SettingsView()
}
