//
//  TestView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/05/14.
//

import SwiftUI
import SwiftData

@Model
final class PokebellUser {
    var phoneNumber: String
    var textNum: String
    var registerDate: Date

    init(phoneNumber: String, textNum: String) {
        self.phoneNumber = phoneNumber
        self.textNum = textNum
        registerDate = Date()
    }
}

struct TestView: View {
    
    @Environment(\.modelContext) private var context
    @Query private var users : [PokebellUser]

    var body: some View {
        VStack {
            List {
                ForEach(users) { user in
                    HStack {
                        Image(systemName: "envelope.fill")
                        Text(user.textNum)
                        Spacer()
                        Image(systemName: "phone.fill")
                        Text(user.phoneNumber)
                    }
                }
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        delete(todo: users[index])
                    }
                })
            }
        }
    }

    private func delete(todo: PokebellUser) {
        context.delete(todo)
    }
}

#Preview {
    TestView()
        .modelContainer(for: PokebellUser.self)
}

