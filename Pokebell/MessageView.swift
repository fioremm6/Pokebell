//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI
import WidgetKit
import SwiftData

//struct MessageView: View {
//    @EnvironmentObject var messageModel: MessageModel
//    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
//    
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(messageModel.messages, id: \.self) { message in
//                    HStack {
//                        Image(systemName: "envelope.fill")
//                        Text(message.text)
//                            .padding(.bottom,5)
//                        Spacer()
//                        Image(systemName: "phone.fill")
//                        Text(message.sender)
//                            .padding(.bottom,5)
//                    }
//                }
//            }
//            .swipeActions {
//                                    // 削除アクション
//                                    Button {
//                                        deleteMessage(message) // メッセージを削除
//                                    } label: {
//                                        Image(systemName: "trash.fill") // SFSymbolのゴミ箱アイコン
//                                    }
//                                    .tint(.red) // 削除ボタンの色を赤に設定
//                                }
//                            }
//                            .onDelete(perform: deleteMessages) // スワイプで削除できるようにする
//                        }
//            .listStyle(.plain)
//            .refreshable {
//                WidgetCenter.shared.reloadAllTimelines()
//                Task {
//                    do {
//                        let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)
//                        messageModel.messages = messages
//                    } catch{
//                        print(error.localizedDescription)
//                    }
//                }
//            }
//            
//            .navigationBarTitleTextColor(Color("blackgray"))
//            .navigationTitle(phoneNumber)
//            .background(Color("pink3"))
//            .foregroundColor(Color("blackgray"))
//            .font(.custom("x8y12pxTheStrongGamer", size: 15))
//            
//        }
//        
//    }
//    
//    
//    
//}
//private func deleteMessage(_ message: Message) {
//        // ここでメッセージを削除する処理（例: Firestoreから削除）
//        if let index = messageModel.messages.firstIndex(where: { $0.id == message.id }) {
//            messageModel.messages.remove(at: index)
//        }
//        // Firestoreからも削除する処理を追加する必要があれば、ここにコードを書く
//        // 例えば、FirestoreClient.deleteMessage(id: message.id) など
//    }
//
//    // スワイプ削除用のメソッド
//    private func deleteMessages(at offsets: IndexSet) {
//        messageModel.messages.remove(atOffsets: offsets)
//        // Firestoreからも削除する処理を追加する必要があれば、ここにコードを書く
//        // 例えば、FirestoreClient.deleteMessages(ids: messagesToDeleteIDs) など
//    }
//extension View {
//    func navigationBarTitleTextColor(_ color: Color) -> some View {
//        let uiColor = UIColor(color)
//        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor, .font: UIFont(name: "x8y12pxTheStrongGamer", size: 30)!]
//        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor, .font: UIFont(name: "x8y12pxTheStrongGamer", size: 30)!]
//        return self
//    }
//}
//
//
//
//
//
//#Preview {
//    MessageView()
//}

struct MessageView: View {
    
    @Query private var users : [PokebellUser]
    
    @EnvironmentObject var messageModel: MessageModel
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    
    var body: some View {
        NavigationView {
            List {
                ForEach(messageModel.messages, id: \.self) { message in
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
            .listStyle(.plain)
            .refreshable {
                // リフレッシュ時にFirestoreから最新のメッセージを取得
                WidgetCenter.shared.reloadAllTimelines()
                Task {
                    do {
                        // Firestoreからメッセージを再取得
                        let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)
                        messageModel.messages = messages
                    } catch {
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
    
    // メッセージを削除するメソッド
    private func deleteMessage(_ message: Message) {
        // メッセージのIDがnilでないか確認
        guard let messageId = message.id else {
            print("Message ID is nil, cannot delete message.")
            return
        }

        // Firestoreからも削除する処理を追加
        Task {
            do {
                // Firestoreからメッセージを削除
                try await FirestoreClient.deleteMessage(id: messageId)
                
                // ローカルのメッセージリストから削除
                if let index = messageModel.messages.firstIndex(where: { $0.id == messageId }) {
                    messageModel.messages.remove(at: index)
                }
            } catch {
                print("Error deleting message: \(error.localizedDescription)")
            }
        }
    }
    // スワイプ削除用のメソッド
    private func deleteMessages(at offsets: IndexSet) {
        // 削除対象のメッセージを取得
        let messagesToDelete = offsets.map { messageModel.messages[$0] }
        
        // Firestoreからも削除
        Task {
            do {
                // Firestoreからメッセージを削除
                try await FirestoreClient.deleteMessages(ids: messagesToDelete.map { $0.id! })
                
                // ローカルのメッセージリストから削除
                messageModel.messages.remove(atOffsets: offsets)
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
