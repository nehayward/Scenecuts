import SwiftUI
import KeyboardShortcuts
import SFSafeSymbols

struct SceneTableSettingsView: View {
    @ObservedObject var helper: Helper
    @State private var sortOrder = [KeyPathComparator(\SceneStatusBarItem.sortPosition)]
    @State var showIconSelection = false
    @State var selectedScene: Int = 0

    private func getIndex(scene: SceneStatusBarItem) -> Int {
        guard let index = helper.scenes.firstIndex (where: {
            $0.id == scene.id
        }) else {
            return 0
        }

        return index
    }

    var body: some View {
        Table(helper.scenes, sortOrder: $sortOrder) {
            TableColumn(Localized.showInMenuBar) { scene in
                Toggle("", isOn: $helper.scenes[getIndex(scene: scene)].isInMenuBar)
            }
            .width(100)
            TableColumn("Name", value: \.name)
            TableColumn(Localized.menuBarIcon) { scene in
                menuBarIcon(scene: scene)
            }
            .width(100)
            TableColumn(Localized.globalShortcut) { scene in
                KeyboardShortcuts.Recorder(
                    for: KeyboardShortcuts.Name(
                        scene.name
                    )
                )
            }

            TableColumn(Localized.showInMenuList) { scene in
                Toggle("", isOn: $helper.scenes[getIndex(scene: scene)].showInMenuList)
            }
        }
        .onChange(of: sortOrder) { newOrder in
            helper.scenes.sort(using: newOrder)
        }
        .sheet(isPresented: $showIconSelection) {
            IconSelectionView(scene: helper.scenes[selectedScene])
                .frame(width: 800, height: 600)
        }
    }

    #warning("TODO: Need to add way to store sort order")
    func move(from source: IndexSet, to destination: Int) {
        StatusBarController.shared.moveMenuItem(from: source, to: destination)
        helper.scenes.move(fromOffsets: source, toOffset: destination)
    }

    @ViewBuilder
    private func menuBarIcon(scene: SceneStatusBarItem) -> some View {
        @ObservedObject var scene: SceneStatusBarItem = helper.scenes[getIndex(scene: scene)]

        HStack {
            if !scene.iconName.isEmpty {
                Button {
                    print("DELETEd")
                    scene.iconName = ""
                    if scene.isInMenuBar {
                        scene.isInMenuBar.toggle()
                        scene.isInMenuBar.toggle()
                    }
                } label: {
                    Image(systemSymbol: .xmarkCircleFill)
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                }
                .buttonStyle(.borderless)
            }
            Button {
                showIconSelection = true
                selectedScene = getIndex(scene: scene)
            } label: {
                if scene.iconName.isEmpty {
                    Text(Localized.setImage.localizedCapitalized)
                        .foregroundColor(.primary)
                } else {
                    Image(systemName: scene.iconName)
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                }
            }
            .buttonStyle(.bordered)
        }
    }
}




extension SceneTableSettingsView {
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
    SceneTableSettingsView(helper: HelperManager.shared.helper)
        .onAppear {
            HelperManager.shared.getScenes()
        }
}

#Preview {
    SceneTableSettingsView(helper: HelperManager.shared.helper)
}
