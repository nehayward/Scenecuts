//
//  GeneralSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var helper: Helper

    var body: some View {
        Form {
            VStack(alignment:.leading, spacing: 20) {
                HStack(alignment: .top) {
                    Text("Helper App: ")
                        .frame(width: 100, alignment: .trailing)
                    VStack(alignment: .leading) {
                        Text(helper.helperAppIsRunning ? "Is Active": "Not Active")
                        if !helper.helperAppIsRunning {
                            Button("Start Helper") {
                                #warning("TODO: Add restart for launcher")
                                HelperManager.shared.launchHelper()
                            }
                        }
                    }
                }
            }
        }
    }
}

struct GeneralSettingsTab_Previews: PreviewProvider {
    static var previews: some View {
        GeneralSettingsView(helper: HelperManager.shared.helper)
    }
}
