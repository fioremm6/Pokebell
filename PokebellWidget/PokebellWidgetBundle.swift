//
//  PokebellWidgetBundle.swift
//  PokebellWidget
//
//  Created by 菊地桃々 on 2025/01/22.
//

import WidgetKit
import SwiftUI
import Firebase

@main
struct PokebellWidgetBundle: WidgetBundle {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Widget {
        PokebellWidget()
    }
}
