//
//  ScenecutsHelperApp.swift
//  ScenecutsHelper
//
//  Created by Nick Hayward on 10/29/20.
//

import SwiftUI

@main
struct ScenecutsHelperApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    init() {
        Home.shared.setup()
    }
    
    var body: some Scene {
        WindowGroup {
            URLView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(launchOptions)
        Home.shared.setup()
        return false
    }
    
    
//
//
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        URLContexts.forEach { (context) in
//            print(context.options.sourceApplication)
//            let url = context.url
//            // Process the URL.
//            guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
//                  let path = components.path,
//                  let params = components.queryItems else {
//                print("Invalid URL or path missing")
//                return
//            }
//
//            print(path)
//            if let commaSeparatedNames = params.first(where: { $0.name == "names" })?.value {
//                let names = commaSeparatedNames.components(separatedBy: ",")
//
//                return
//            }
//
//            print(Home.shared.homeManager.primaryHome?.actionSets)
//
//        }
//    }
//
//    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
//      guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
//        let urlToOpen = userActivity.webpageURL else {
//          return
//      }
//
//      print(urlToOpen)
//    }
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//      self.scene(scene, openURLContexts: connectionOptions.urlContexts)
//    }
    
    
}


