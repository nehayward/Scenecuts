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
                        if helper.helperAppIsRunning {
                            Text(HelperManager.shared.helperAppInformation)
                                .frame(height: 50, alignment: .topLeading)
                                .lineLimit(3)
                        }
                        if !helper.helperAppIsRunning {
                            Button("Start Helper") {
                                HelperManager.shared.launchHelper()
                            }
                        } else {
                            Button("Terminate Helper") {
                                HelperManager.shared.terminateHelper()
                            }
                        }
                        Text("The helper app is used to communicate with HomeKit, this\nneeds to be running in order for Scenecuts to work properly.")
                            .font(.footnote)
                            .foregroundColor(.secondary)
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
