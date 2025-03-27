//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI
import WidgetKit

struct MessageView: View {
    @EnvironmentObject var messageModel: MessageModel
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue) var phoneNumber = ""
    
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
                WidgetCenter.shared.reloadAllTimelines()
                Task {
                    do {
                        let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)
                        messageModel.messages = messages
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
