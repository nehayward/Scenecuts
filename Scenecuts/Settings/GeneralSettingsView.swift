import SwiftUI

struct GeneralSettingsView: View {
    @ObservedObject var helper: Helper

    var body: some View {
        Form {
            VStack(alignment:.leading, spacing: 20) {
                HStack(alignment: .top) {
                    Text(Localized.helperApp.localizedCapitalized + ": ")
                        .frame(width: 100, alignment: .trailing)
                    VStack(alignment: .leading) {
                        if helper.helperAppIsRunning {
                            Text(HelperManager.shared.helperAppInformation)
                                .frame(height: 50, alignment: .topLeading)
                                .lineLimit(3)
                        }
                        if !helper.helperAppIsRunning {
                            Button(Localized.startHelperApp.localizedCapitalized) {
                                HelperManager.shared.launchHelper()
                            }
                        } else {
                            Button(Localized.terminateHelperApp.localizedCapitalized) {
                                HelperManager.shared.terminateHelper()
                            }
                        }
                        Text(Localized.helperAppButtonInfo)
                            .frame(width: 300, alignment: .leading)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

extension GeneralSettingsView {
    enum Localized {
        static var helperApp: String {
            .localizedStringWithFormat(NSLocalizedString("Helper App", comment: "The name for a helper app"))
        }
        
        static var startHelperApp: String {
            .localizedStringWithFormat(NSLocalizedString("Start App", comment: "A button to start helper app."))
        }
        
        static var terminateHelperApp: String {
            .localizedStringWithFormat(NSLocalizedString("Terminate App", comment: "A button to terminate helper app."))
        }
        
        static var helperAppButtonInfo: String {
            .localizedStringWithFormat(NSLocalizedString("The helper app is used to communicate with HomeKit, this needs to be running in order for Scenecuts to work properly.", comment: "A brief message explaining that Helper App must be running for Scenecuts to work properly"))
        }
    }
}

#Preview {
    GeneralSettingsView(helper: HelperManager.shared.helper)
}
