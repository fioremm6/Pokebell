//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI

struct MessageView: View {
    @EnvironmentObject var messageModel: MessageModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messageModel.messages, id: \.self) { message in
                    Text(message)
                        .padding()
                }
            }
            .navigationTitle("メッセージ履歴")
        }
    }
}


    

#Preview {
    MessageView()
}
