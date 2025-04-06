//
//  CustomView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI
import WidgetKit

//struct CustomView: View {
//    
//    
//    var body: some View {
//        VStack {
//            Text("カスタム")
//        }}
//}
//import SwiftUI
struct CustomView: View {
    // ユーザーが選択した色を保持
    @State private var selectedColor: String = appGroupUserDefaults.string(forKey: "WidgetColor") ?? "pink3"


    var body: some View {
        VStack {
            Text("Select Widget Color")
                .font(.headline)
                .padding()

            // 赤、黄色、青の3色をボタンで選ばせる
            HStack {
                Button(action: {
                    selectedColor = "widgetred"
                    appGroupUserDefaults.set("widgetred", forKey: "WidgetColor")
                    refreshWidget()
                    
                }) {
                    Text("Red")
                        .padding()
                        .background(Color.red)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }

                Button(action: {
                    selectedColor = "widgetyellow"
                    appGroupUserDefaults.set("widgetyellow", forKey: "WidgetColor")
                    refreshWidget()
                   
                }) {
                    Text("Yellow")
                        .padding()
                        .background(Color.yellow)
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }

                Button(action: {
                    selectedColor = "widgetblue"
                    appGroupUserDefaults.set("widgetblue", forKey: "WidgetColor")
                    refreshWidget()
                   
                }) {
                    Text("Blue")
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .padding()
    }
    private func refreshWidget() {
            WidgetCenter.shared.reloadAllTimelines()
        }
}

