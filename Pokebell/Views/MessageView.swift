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



struct MessageView: View {
    
    @FirestoreQuery(collectionPath: "messages") var messages: [Message]
    
    
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    
    var filteredMessages: [Message] {
        messages
            .filter { $0.receiver == phoneNumber }
            .sorted { m0, m1 in
                m0.date.dateValue() > m1.date.dateValue()
            }
    }
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color("pink3")
                .ignoresSafeArea()
            VStack {
                NavigationView {
                    List {
                        ForEach(filteredMessages, id: \.self) { message in
                            HStack {
                                Image(systemName: "envelope.fill")
                                Text(message.text)
                                    .padding(.bottom, 5)
                                Spacer()
                                Image(systemName: "phone.fill")
                                Text(message.sender)
                                    .padding(.bottom, 5)
                            }
                            .swipeActions {
                                // 削除アクション
                                Button {
                                    deleteMessage(message) // メッセージを削除
                                } label: {
                                    Image(systemName: "trash.fill") // SFSymbolのゴミ箱アイコン
                                }
                                .tint(.red) // 削除ボタンの色を赤に設定
                            }
                        }
                        .onDelete(perform: deleteMessages) // スワイプで削除できるようにする
                    }
                    //            .listStyle(.plain)
                    .onChange(of: filteredMessages){
                        
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                    .navigationBarTitleTextColor(Color("blackgray"))
                    .navigationTitle(phoneNumber)
                    .foregroundColor(Color("blackgray"))
                    .font(.custom("x8y12pxTheStrongGamer", size: 15))
                    .onDisappear {
                        print("testt")
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                }
            }
        }
    }
    
    // メッセージを削除するメソッド
    private func deleteMessage(_ filteredMessages: Message) {
        // メッセージのIDがnilでないか確認
        guard let messageId = filteredMessages.id else {
            print("Message ID is nil, cannot delete message.")
            return
        }
        
        // Firestoreからも削除する処理を追加
        Task {
            do {
                // Firestoreからメッセージを削除
                try await FirestoreClient.deleteMessage(id: messageId)
                
                // ローカルのメッセージリストから削除
                //                if let index = messages.firstIndex(where: { $0.id == messageId }) {
                //                    messageModel.messages.remove(at: index)
                //                }
            } catch {
                print("Error deleting message: \(error.localizedDescription)")
            }
        }
    }
    // スワイプ削除用のメソッド
    private func deleteMessages(at offsets: IndexSet) {
        // 削除対象のメッセージを取得
        let messagesToDelete = offsets.map { filteredMessages[$0] }
        
        // Firestoreからも削除
        Task {
            do {
                // Firestoreからメッセージを削除
                try await FirestoreClient.deleteMessages(ids: messagesToDelete.map { $0.id! })
                
                // ローカルのメッセージリストから削除
                //                messageModel.messages.remove(atOffsets: offsets)
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
