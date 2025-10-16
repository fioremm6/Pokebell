//
//  ContentView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI

class MessageModel: ObservableObject {
    @Published var messages: [Message] = []
}
struct ContentView: View {
    @StateObject private var messageModel = MessageModel()
    
    var body: some View {
        TabView {
            CustomView()
                .tabItem {
                    Label("Custom", systemImage: "paintpalette")
                }
                .environmentObject(messageModel)
            PhoneView()
                .tabItem {
                    Label("Send", systemImage: "paperplane")
                }
                .environmentObject(messageModel)
            
            MessageView()
                .tabItem {
                    Label("Message", systemImage: "message")
                }
                .environmentObject(messageModel) 
        }
        .accentColor(Color("blackgray"))
    }
}






#Preview {
    ContentView()
}
