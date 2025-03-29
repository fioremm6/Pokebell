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
                        Image(systemName: "envelope.fill")
                        Text(message.text)
                        Spacer()
                        Image(systemName: "phone.fill")
                        Text(message.sender)
                    }
                }
            }
            .listStyle(.plain)
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
            .background(Color("pokepink"))
            .navigationTitle(phoneNumber)
        }
    }
    
    
    
}





#Preview {
    MessageView()
}
