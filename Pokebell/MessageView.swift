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
                        HStack {
                            Text(message.text)
                                .padding()
                            Text(message.sender)
                        }
                    }
                }
                .refreshable {
                    Task {
                        do {
                            messageModel.messages = try await FirestoreClient.fetchMessage()
                        } catch{
                            print(error.localizedDescription)
                        }
                    }
                }
                .navigationTitle("メッセージ履歴")
                .background(Color("pokepink"))
            }
        }
    }



    

#Preview {
    MessageView()
}
