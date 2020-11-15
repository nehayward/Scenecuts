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
    
    var rows: [GridItem] = Array(repeating: .init(.fixed(50)), count: 3)
    
    var body: some View {
        VStack {
            VStack {
                if !scene.iconName.isEmpty {
                    Text("Current Icon").padding(.bottom, 2)
                    Image(systemName: scene.iconName)
                        .font(.system(size: 60))
                    Button("Clear") {
                        scene.iconName = ""
                    }
                } else {
                    Text("Select an Icon")
                        .font(.title)
                }
            }
            TextField("Search for SFSymbols...", text: $filterText, onEditingChanged: { isEditing in
              
            }, onCommit: {
                print("onCommit")
            }).textFieldStyle(RoundedBorderTextFieldStyle())

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
                Button("Cancel") {
                    // MARK: Reset State
                    scene.iconName = originalIconName
                    dismiss = false
                }.keyboardShortcut(.cancelAction)
                Button("Apply") {
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

struct IconSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        IconSelectionView(scene: SceneStatusBarItem(id: UUID(),
                                                    name: "Test",
                                                    iconName: "tv",
                                                    shortcut: "",
                                                    isInMenuBar: false),
        dismiss: .constant(true))
    }
}

