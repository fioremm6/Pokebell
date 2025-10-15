//
//  UserDefaultskey.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/10/15.
//


import Foundation

enum UserDefaultsKey2: String {
    case phoneNumber
    case date
    case saishinMessage
    
    private static let sharedUserDefaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")!
    
    static subscript<T>(key: Self, type: T.Type = T.self) -> T? {
        get {
            sharedUserDefaults.object(forKey: key.rawValue) as? T
        }
        set {
            sharedUserDefaults.set(newValue, forKey: key.rawValue)
        }
    }
    
    func remove() {
        UserDefaultsKey2.sharedUserDefaults.removeObject(forKey: rawValue)
    }
    
    var exists: Bool {
        UserDefaultsKey2.sharedUserDefaults.object(forKey: rawValue) != nil
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

