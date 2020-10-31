//
//  URLView.swift
//  ScenecutsHelper
//
//  Created by Nick Hayward on 10/31/20.
//

import Foundation
import SwiftUI

// MARK: Workaround for handling URL in SwiftUI App Life Cycle
struct URLView: View {
    var body: some View {
        Text("Scenecuts Helper")
            .padding()
            .onOpenURL { (url) in
                print(url)
                let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
                guard let id = components?.queryItems?.first(where: {$0.name == "uuid"})?.value else { return }
                
                Home.shared.executeAction(with: id)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        URLView()
    }
}
