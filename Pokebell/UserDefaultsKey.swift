//
//  UserDefaultsKey.swift
//  iWant
//
//  Created by Kyoya Yamaguchi on 2024/05/30.
//

import Foundation

enum UserDefaultsKey: String {
    case phoneNumber
    case date
    
    private static let sharedUserDefaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebell")!
    
    static subscript<T>(key: Self, type: T.Type = T.self) -> T? {
        get {
            sharedUserDefaults.object(forKey: key.rawValue) as? T
        }
        set {
            sharedUserDefaults.set(newValue, forKey: key.rawValue)
        }
    }
    
    func remove() {
        UserDefaultsKey.sharedUserDefaults.removeObject(forKey: rawValue)
    }
    
    var exists: Bool {
        UserDefaultsKey.sharedUserDefaults.object(forKey: rawValue) != nil
    }
}

/*
 
値を保存する
UserDefaultsKey[.tutorialShown] = true
 
 
値を使う
if let hasReviewed: Bool = UserDefaultsKey[.hasReviewed], hasReviewed {
    print(hasReviewed)
}
 
SwiftUIで簡単に使う
@AppStorage(UserDefaultsKey.openInExternalBrowser.rawValue) var openInExternalBrowser = false
 
 */
