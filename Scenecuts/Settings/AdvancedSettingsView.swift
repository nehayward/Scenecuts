//
//  AdvanceSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/28/20.
//

import SwiftUI

struct AdvancedSettingsView: View {
    @AppStorage("hidePreferencesOnLaunch") var hidePreferencesOnLaunch: Bool = false

    var body: some View {
        Form {
            VStack(alignment:.leading, spacing: 20) {
                HStack(alignment: .top) {
                    Text("Advanced: ")
                        .frame(width: 100, alignment: .trailing)
                    VStack(alignment: .leading) {
                        Toggle("Hide Preferences on Launch", isOn: $hidePreferencesOnLaunch)
                        Text("Enabling this will always hide the preference window on first app launch.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}
