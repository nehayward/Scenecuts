//
//  ImageView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 11/13/20.
//

import SwiftUI


struct IconSelectionView: View {
    var scene: SceneStatusBarItem
    @Binding var dismiss: Bool
    @State var filterText: String = ""
    @State var originalIconName = ""
    
    let data = (1...1000).map { "Item \($0)" }
    
    let columns = [
        GridItem(.adaptive(minimum: 50))
    ]
    
    var body: some View {
        VStack {
            VStack {
                if !scene.iconName.isEmpty {
                    Image(systemName: scene.iconName)
                        .font(.system(size: 60))
                        .padding()
                    Text("Current Icon")
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
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(data.filter{$0.lowercased().hasPrefix(filterText.lowercased()) || filterText.lowercased() == ""}, id: \.self) { item in
                        Button (action: {
                            scene.iconName = "gamecontroller"
                        }) {
                            VStack {
                                Image(systemName: "gamecontroller")
                                    .font(.title)
                                Text(item)
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .frame(width: 50, height: 50)
                    }
                }
                .padding(.horizontal)
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
                    if scene.isInMenuBar, !scene.iconName.isEmpty {
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
