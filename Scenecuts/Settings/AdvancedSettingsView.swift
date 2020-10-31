//
//  AdvanceSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI
import KeyboardShortcuts
import Combine

class BookItem: ObservableObject, Identifiable, Equatable {
    internal init(name: String, enabled: Bool) {
        self.name = name
        self.enabled = enabled
    }
    
    static func == (lhs: BookItem, rhs: BookItem) -> Bool {
        lhs.id == rhs.id
    }
    
    let id = UUID()
    let name: String
    @Published var enabled: Bool
    
}

struct AdvancedSettingsView: View {
    @ObservedObject var book: BookItem
    @ObservedObject var helper: Helper
    @State private var route = false

    var body: some View {
        
        Form {
            ForEach(helper.scenes.indices,id: \.self){ index in
                HStack {
                    Text(helper.scenes[index].name)
                    Spacer()
                    Toggle("Show in Menubar", isOn: $helper.scenes[index].isInMenuBar)
                    
//                    KeyboardShortcuts.Recorder(for: KeyboardShortcuts.Name(scene.id.uuidString))
                }
            }
//            ForEach(helper.$scenes, id: \.self) { item in
//                HStack {
//                    Text(item.name)
//                    Image(systemName: item.icon)
//                    Toggle("Show in Menubar", isOn: $showInMenuBar)
//                        .onChange(of: showInMenuBar) { (newValue) in
//                            print(newValue)
//                            StatusBarController.shared.sceneMenuBarItems[0].showInMenuBar = newValue
//                        }
//
//                    KeyboardShortcuts.Recorder(for: .pref)
//                }
//            }
            //
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                Toggle("Show in Menubar", isOn: $showInMenuBar)
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //            HStack {
            //                Text("Brandford")
            //                Image(systemName: "house")
            //                KeyboardShortcuts.Recorder(for: .pref)
            //            }
            //
            
        }
    }
    
    
}

//class StatusItems: Identifiable, ObservableObject {
//    let id: UUID = UUID()
//    var name: String = ""
//    var iconName: String = ""
////    var showInStatusBar: Bool
//    @Published private(set) var showInStatusBar: Bool = false
//}

//struct AdvanceSettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AdvancedSettingsView()
//    }
//}

extension KeyboardShortcuts.Name {
    static let pref = Self("pref", default: Shortcut(.t, modifiers: [.command,.control,.shift]))
}
