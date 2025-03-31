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
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Bellmy")) var phoneNumber = ""
    
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
            .navigationBarTitleTextColor(Color("blackgray"))
            .navigationTitle(phoneNumber)
            .background(Color("pink3"))
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
        
    }
    
    
    
}
extension View {
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor, .font: UIFont(name: "x8y12pxTheStrongGamer", size: 30)!]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor, .font: UIFont(name: "x8y12pxTheStrongGamer", size: 30)!]
        return self
    }
}





#Preview {
    MessageView()
}
