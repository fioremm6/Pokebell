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

                }
        }
    }
}

