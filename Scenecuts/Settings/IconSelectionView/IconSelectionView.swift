//
//  ImageView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/13/20.
//

import SwiftUI
import SFSafeSymbols

struct IconSelectionView: View {
    var scene: SceneStatusBarItem
    @Binding var dismiss: Bool
    @State var filterText: String = ""
    @State var originalIconName = ""
    
    var symbols: [Symbol] = {
        let symbols = SFSafeSymbols.SFSymbol.allCases.map { (symbol) in
            Symbol(symbol: symbol)
        }
        return symbols
    }()
    
    var rows: [GridItem] = Array(repeating: .init(.fixed(80)), count: 5)
    
    var body: some View {
        VStack {
            VStack {
                if !scene.iconName.isEmpty {
                    Text(Localized.currentIcon.localizedCapitalized).padding(.bottom, 2)
                    Image(systemName: scene.iconName)
                        .font(.system(size: 60))
                    Button(Localized.clear.localizedCapitalized) {
                        scene.iconName = ""
                    }
                } else {
                    Text(Localized.selectAnIcon)
                        .font(.title)
                }
            }
            TextField("\(Localized.searchPromptPlaceholder)...", text: $filterText).textFieldStyle(RoundedBorderTextFieldStyle())

            ScrollView {
                LazyVGrid(columns: rows) {
                    ForEach(symbols.filter{$0.symbol.rawValue.lowercased().hasPrefix(filterText.lowercased()) || filterText.lowercased() == ""}) { symbol in
                        IconButton(scene: scene, symbol: symbol.symbol)
                    }
                    .padding(.horizontal)
                }
            }
            Spacer()
            HStack {
                Button(Localized.cancel.localizedCapitalized) {
                    // MARK: Reset State
                    scene.iconName = originalIconName
                    dismiss = false
                }.keyboardShortcut(.cancelAction)
                Button(Localized.apply.localizedCapitalized) {
                    // MARK: Reset Menubar State
                    if scene.isInMenuBar {
                        scene.isInMenuBar.toggle()
                        scene.isInMenuBar.toggle()
                    }
                    dismiss = false
                }
                .keyboardShortcut(.defaultAction)
            }
        }.padding()
        .onAppear {
            originalIconName = scene.iconName
        }
    }
}

struct Symbol: Identifiable, Hashable {
    var id = UUID()
    var symbol: SFSymbol
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

struct IconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IconSelectionView(scene: SceneStatusBarItem(id: UUID(),
                                                        name: "Test",
                                                        iconName: "tv",
                                                        shortcut: "",
                                                        isInMenuBar: false,
                                                        showInMenuList: true),
                              dismiss: .constant(true))
            IconSelectionView(scene: SceneStatusBarItem(id: UUID(),
                                                        name: "",
                                                        iconName: "",
                                                        shortcut: "",
                                                        isInMenuBar: false,
                                                        showInMenuList: true),
                              dismiss: .constant(true))
        }
    }
}

