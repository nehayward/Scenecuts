import SwiftUI

struct SceneSettingsView: View {
    @ObservedObject var helper: Helper
    
    var body: some View {
        Form {
            VStack(spacing: 20) {
                HStack(alignment: .center, spacing: 0) {
                    Text(Localized.showInMenuBar)
                        .frame(width: 120)
                    Divider()
                    Text(Localized.sceneName)
                        .frame(width: 140)
                    Divider()
                    Text(Localized.menuBarIcon)
                        .frame(width: 120)
                    Divider()
                    Text(Localized.globalShortcut)
                        .frame(width: 160)
                    Divider()
                    Text(Localized.showInMenuList)
                        .frame(width: 120)
                }
                .frame(height: 30)
                .border(SeparatorShapeStyle())
                
                ScrollView {
                    ForEach(helper.scenes, id: \.self){ scene in
                        SceneConfigurationView(scene: scene)
                    }
                }
                .padding(0)
                .frame(minHeight: 400)
            }
        }
        .padding(.bottom, 20)
        .border(SeparatorShapeStyle())
    }
    
    #warning("TODO: Need to add way to store sort order")
    func move(from source: IndexSet, to destination: Int) {
        StatusBarController.shared.moveMenuItem(from: source, to: destination)
        helper.scenes.move(fromOffsets: source, toOffset: destination)
    }
}


extension SceneSettingsView {
    enum Localized {
        static var showInMenuBar: String {
            .localizedStringWithFormat(NSLocalizedString("Show in Menu Bar", comment: "A column header that shows a list of toggles to show/hide scenes in menu bar."))
        }
        
        static var sceneName: String {
            .localizedStringWithFormat(NSLocalizedString("Name", comment: "A column header that shows a list of scene names."))
        }
        
        static var menuBarIcon: String {
            .localizedStringWithFormat(NSLocalizedString("Menu Bar Icon", comment: "A column header that shows a list of icon buttons to set an icon for the specific scene."))
        }
        
        static var globalShortcut: String {
            .localizedStringWithFormat(NSLocalizedString("Global Shortcut", comment: "A column header that shows a list of buttons to assign a global keyboard shortcut to the specific icon"))
        }
        
        static var showInMenuList: String {
            .localizedStringWithFormat(NSLocalizedString("Show in Menu List", comment: "A column header that shows a list of toggles to show/hide scenes in menu list."))
        }

        static var setImage: String {
            .localizedStringWithFormat(NSLocalizedString("Set Image", comment: "A button that opens a view to assign an icon/image to the scene."))
        }
    }
}


#Preview {
    SceneSettingsView(helper: HelperManager.shared.helper)
        .onAppear {
            HelperManager.shared.getScenes()
        }
}

#Preview {
    SceneSettingsView(helper: HelperManager.shared.helper)
}
