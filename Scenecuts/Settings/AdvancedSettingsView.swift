//
//  AdvanceSettingsView.swift
//  Scenecuts
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI
import KeyboardShortcuts

struct AdvancedSettingsView: View {
    @State var items = StatusBarController.shared.sceneMenuBarItems
    @State var showInMenuBar = false
    
//    @ObservedObject var statusItems: StatusItems
    
    var body: some View {
        
        Form {
            ForEach(items, id: \.self) { item in
                HStack {
                    Text(item.name)
                Image(systemName: item.icon)
                Toggle("Show in Menubar", isOn: $showInMenuBar)
                    .onChange(of: showInMenuBar) { (newValue) in
                        print(newValue)
                        StatusBarController.shared.sceneMenuBarItems[0].showInMenuBar = newValue
                    }

                KeyboardShortcuts.Recorder(for: .pref)
                }
            }
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
            if showInMenuBar {
                EmptyView()
            }
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

struct AdvanceSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedSettingsView()
    }
}

extension KeyboardShortcuts.Name {
    static let pref = Self("pref", default: Shortcut(.t, modifiers: [.command,.control,.shift]))
}
