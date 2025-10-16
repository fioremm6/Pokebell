//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI
import WidgetKit
import TipKit
import FirebaseFirestore
import AudioToolbox




struct MessageView: View {
    
    @FirestoreQuery(collectionPath: "messages") var messages: [Message]
    
    
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    @State private var lastMessageCount = 0
    @State private var isShowingAddressView = false
    @State private var phoneNumInput = ""
    
    var filteredMessages: [Message] {
        messages
            .filter { $0.receiver == phoneNumber }
            .sorted { m0, m1 in
                m0.date.dateValue() > m1.date.dateValue()
            }
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack {
                HStack {
                    Text(phoneNumber)
                        .font(.custom("x8y12pxTheStrongGamer", size: 30))
                        .foregroundColor(Color("blackgray"))
                    Spacer()
                    Button {
                        isShowingAddressView = true
                    } label: {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .font(.system(size: 30))
                            .foregroundColor(Color("blackgray"))
                            .padding(.top,10)
                    }
                    .sheet(isPresented: $isShowingAddressView) {
                        AddressView(phoneNumInput: $phoneNumInput)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                List {
                    ForEach(filteredMessages, id: \.self) { message in
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
                .onChange(of: filteredMessages) { newMessages in
                    guard let latest = newMessages.first else { return }
                    let defaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")
                    let oldMessage = defaults?.string(forKey: "latestMessage")
                    
                    if oldMessage != latest.text {
                        defaults?.set(latest.text, forKey: "latestMessage")
                        defaults?.set(latest.sender, forKey: "latestSender")
                        WidgetCenter.shared.reloadAllTimelines()
                        
                        let content = UNMutableNotificationContent()
                        content.title = latest.sender
                        content.body = latest.text
                        content.sound = UNNotificationSound(named: .init("bellmysound6.caf"))
                        content.userInfo = ["source": "appMessage"]
                        let request = UNNotificationRequest(
                            identifier: UUID().uuidString,
                            content: content,
                            trigger: nil
                        )
                        UNUserNotificationCenter.current().add(request)
                        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                        
                        let numberOfVibrations = 6
                        let totalDuration: TimeInterval = 4
                        let interval = totalDuration / Double(numberOfVibrations)
                        
                        for i in 0..<numberOfVibrations {
                            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
                            }
                        }
                    }
                }
                .foregroundColor(Color("blackgray"))
                .font(.custom("x8y12pxTheStrongGamer", size: 15))
                .onDisappear {
                    print("testt")
                    
                    WidgetCenter.shared.reloadAllTimelines()
                }
            }
            
        }
    }
    
    
    
    private func deleteMessage(_ filteredMessages: Message) {
        
        guard let messageId = filteredMessages.id else {
            print("Message ID is nil, cannot delete message.")
            return
        }
        
        
        Task {
            do {
                
                try await FirestoreClient.deleteMessage(id: messageId)
            } catch {
                print("Error deleting message: \(error.localizedDescription)")
            }
        }
    }
    
    private func deleteMessages(at offsets: IndexSet) {
        
        let messagesToDelete = offsets.map { filteredMessages[$0] }
        
        Task {
            do {
                
                try await FirestoreClient.deleteMessages(ids: messagesToDelete.map { $0.id! })
                
                
            } catch {
                print("Error deleting messages: \(error.localizedDescription)")
            }
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



