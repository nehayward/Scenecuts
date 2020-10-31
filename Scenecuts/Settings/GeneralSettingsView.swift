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
            VStack {
                Text(helper.helperAppIsRunning ? "Is Active" : "Not Active")
                Button("Activate Helper") {
                    HelperManager.shared.launchHelper()
                }
            }
        }
    }
}

//struct GeneralSettingsTab_Previews: PreviewProvider {
//    static var previews: some View {
//        GeneralSettingsView(isOn: .constant(false))
//    }
//}
