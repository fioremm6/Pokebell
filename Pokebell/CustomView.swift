//
//  CustomView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI
import WidgetKit



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
                    selectedColor = "pink3"
                    appGroupUserDefaults.set("pink3", forKey: "WidgetColor")
                    refreshWidget()
                    
                }) {
                    Text("Original")
                        .padding()
                        .background(Color("pink3"))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }

                Button(action: {
                    selectedColor = "lightgray"
                    appGroupUserDefaults.set("lightgray", forKey: "WidgetColor")
                    refreshWidget()
                   
                }) {
                    Text("Gray")
                        .padding()
                        .background(Color("lightgray"))
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
                        .background(Color("widgetblue"))
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

