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
                PhoneView()
                    .tabItem {
                        Label("send", systemImage: "square.and.pencil")
                    }
                    .environmentObject(messageModel) // 共有データ
                CustomView()
                    .tabItem {
                        Label("custom", systemImage: "plus.circle.fill")
                    }
                    .environmentObject(messageModel) // 共有データ
                
                MessageView()
                    .tabItem {
                        Label("message", systemImage: "list.bullet")
                    }
                    .environmentObject(messageModel) // 共有データ
                TestView()
                    .tabItem {
                        Label("message", systemImage: "list.bullet")
                    }
                    .environmentObject(messageModel)
            }
            .accentColor(Color("blackgray"))
        }
    }



    


#Preview {
    ContentView()
}
