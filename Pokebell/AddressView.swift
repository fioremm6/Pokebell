//
//  AddressView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI

struct AddressView: View {
    @EnvironmentObject var messageModel: MessageModel
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    @State private var senderNames: [String: String] = [:]
    
    
    private var uniqueSenders: [String] {
        let senders = messageModel.messages.map { $0.sender }
        return Array(Set(senders)).sorted()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(uniqueSenders, id: \.self) { sender in
                    HStack {
                        Image(systemName: "phone.fill")
                        Text(sender)
                            .padding(.bottom, 5)
                        Spacer()
                        Image(systemName: "person.fill")
                        if let savedName = senderNames[sender], !savedName.isEmpty {
                            Text(savedName)
                                .padding(.bottom, 5)
                        } else {
                            TextField("Enter name", text: Binding(
                                get: { self.senderNames[sender] ?? "" },
                                set: { newName in
                                    self.senderNames[sender] = newName
                                    UserDefaults.standard.set(newName, forKey: sender)
                                }
                            ))
                            .padding(5)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 150)
                            
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitleTextColor(Color("blackgray"))
            .navigationTitle("Friends")
            .background(Color("pink3"))
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
        .onAppear {
            loadSavedNames()
            
        }
    }
        private func loadSavedNames() {
                for sender in uniqueSenders {
                    if let savedName = UserDefaults.standard.string(forKey: sender) {
                        senderNames[sender] = savedName
                    }
                }
            }
    
}


