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
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebell")) var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messageModel.messages, id: \.self) { message in
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text(message.text)
                            .padding(.bottom,5)
                        Spacer()
                        Image(systemName: "phone.fill")
                        Text(message.sender)
                            .padding(.bottom,5)
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
            .background(Color("pink3"))
            .navigationTitle(phoneNumber)
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
        
    }
    
    
    
}





#Preview {
    MessageView()
}
