//
//  PokebellApp.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI
import Firebase
import AppTrackingTransparency
//import GoogleMobileAds


@main
struct PokebellApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
   
    var body: some Scene {
        WindowGroup {
            ContentView()
                
                .task {
//#if DEBUG
//MobileAds.shared.requestConfiguration.testDeviceIdentifiers = [ "23d075f13263d1651e62275ad58fdb1" ]
//#endif
//await ATTrackingManager.requestTrackingAuthorization()
//await MobileAds.shared.start()
                }
        }
//        .modelContainer(for: PokebellUser.self)
    }
}

//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        FirebaseApp.configure()
//        return true
//    }
//}
