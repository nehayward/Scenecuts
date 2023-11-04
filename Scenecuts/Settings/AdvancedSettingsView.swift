import LaunchAtLogin
import SwiftUI

struct AdvancedSettingsView: View {
    @AppStorage("hidePreferencesOnLaunch") var hidePreferencesOnLaunch: Bool = false

    var body: some View {
        Form {
            VStack(alignment:.leading, spacing: 20) {
                HStack(alignment: .top) {
                    Text("\(Localized.advanced.localizedCapitalized): ")
                        .frame(width: 100, alignment: .trailing)
                    VStack(alignment: .leading) {
                        Toggle(Localized.hidePreferencesOnLaunch, isOn: $hidePreferencesOnLaunch)
                        Text(Localized.hidePreferencesOnLaunchFooterInformation)
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        LaunchAtLogin.Toggle()
                    }
                }
            }
        }
    }
}

extension AdvancedSettingsView {
    enum Localized {
        static var advanced: String {
            .localizedStringWithFormat(NSLocalizedString("Advanced", comment: "A label listing advanced configuration options."))
        }
        
        static var hidePreferencesOnLaunch: String {
            .localizedStringWithFormat(NSLocalizedString("Hide Preferences on Launch", comment: "A toggle label that will enable/disable showing preferences screen on application launch"))
        }
        
        static var hidePreferencesOnLaunchFooterInformation: String {
            .localizedStringWithFormat(NSLocalizedString("Enabling this will always hide the preference window on first app launch.", comment: "Explanation of 'Hide Preferences on Launch' toggle."))
        }
    }
}


struct AdvancedSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}
