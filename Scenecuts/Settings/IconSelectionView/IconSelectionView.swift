//
//  ImageView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/13/20.
//

import SwiftUI
import SFSafeSymbols
import WidgetKit

struct IconSelectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var scene: SceneStatusBarItem
    @State var filterText: String = ""
    @State var originalIconName = ""

    var symbols: [SFSymbol] = {
        SFSafeSymbols.SFSymbol.allSymbols.sorted(by: { a, b in
            a.rawValue < b.rawValue
        })
    }()

    var rows: [GridItem] = Array(repeating: .init(.fixed(200)), count: 6)

    var body: some View {
        VStack {
            VStack {
                if !scene.iconName.isEmpty {
                    Text(Localized.currentIcon.localizedCapitalized).padding(.bottom, 2)
                    Image(systemName: scene.iconName)
                        .renderingMode(.template)
                        .foregroundColor(.primary)
                        .font(.system(size: 60))
                    Button(Localized.clear.localizedCapitalized) {
                        scene.iconName = ""
                    }
                    .transition(.scale)
                } else {
                    Text(Localized.selectAnIcon)
                        .font(.title)
                }
            }

            TextField("\(Localized.searchPromptPlaceholder)...", text: $filterText)

            ScrollView {
                LazyVGrid(columns: rows) {
                    ForEach(symbols.filter{$0.rawValue.lowercased().hasPrefix(filterText.lowercased()) || filterText.lowercased() == ""}, id: \.self) { symbol in
                        IconButton(scene: scene, symbol: symbol)
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
            HStack {
                Button(Localized.cancel.localizedCapitalized) {
                    // MARK: Reset State
                    scene.iconName = originalIconName
                    dismiss()
                }
                .foregroundColor(.primary)
                .keyboardShortcut(.cancelAction)

                Button(Localized.apply.localizedCapitalized) {
                    // MARK: Reset Menubar State
                    if scene.isInMenuBar {
                        scene.isInMenuBar.toggle()
                        scene.isInMenuBar.toggle()
                    }
                    dismiss()

                    // MARK: Reload widget
                    WidgetCenter.shared.reloadAllTimelines()
                }
                .foregroundColor(.primary)
                .keyboardShortcut(.defaultAction)
            }
        }
        .padding()
        .onAppear {
            originalIconName = scene.iconName
        }
        .animation(.spring, value: scene)
    }
}

extension IconSelectionView {
    enum Localized {
        static var currentIcon: String {
            .localizedStringWithFormat(NSLocalizedString("Current Icon", comment: "A header label for current icon selected"))
        }

        static var clear: String {
            .localizedStringWithFormat(NSLocalizedString("Clear", comment: "A button to clear icon image selection"))
        }

        static var selectAnIcon: String {
            .localizedStringWithFormat(NSLocalizedString("Select an Icon", comment: "A header label that indicates icon can be selected"))
        }

        static var searchPromptPlaceholder: String {
            .localizedStringWithFormat(NSLocalizedString("Search for SFSymbols", comment: "A placeholder for searching for SFSymbols"))
        }

        static var cancel: String {
            .localizedStringWithFormat(NSLocalizedString("Cancel", comment: "A button that cancels selected icon change."))
        }

        static var apply: String {
            .localizedStringWithFormat(NSLocalizedString("Apply", comment: "A button that applies selected icon change."))
        }
    }
}

//struct IconSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            IconSelectionView(scene: SceneStatusBarItem(id: UUID(),
//                                                        name: "Test",
//                                                        iconName: "tv",
//                                                        shortcut: "",
//                                                        actionType: .userDefined,
//                                                        isInMenuBar: false,
//                                                        showInMenuList: true))
//            IconSelectionView(scene: SceneStatusBarItem(id: UUID(),
//                                                        name: "",
//                                                        iconName: "",
//                                                        shortcut: "",
//                                                        actionType: .userDefined,
//                                                        isInMenuBar: false,
//                                                        showInMenuList: true))
//        }
//    }
//}
//
