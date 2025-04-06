//
//  AddressView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI


struct AddressView: View {
    @EnvironmentObject var messageModel: MessageModel
    @AppStorage("phoneNumber", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    @AppStorage("name", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var name = ""
    
    @State private var isPresented = false
    @State private var phonetext = ""
    @State private var nametext = ""
    
    // UserDefaultsから電話番号と名前を配列で読み込む
    @AppStorage("friends", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) private var friendsData: Data = Data()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Friends")
                        .font(.custom("x8y12pxTheStrongGamer", size: 30))
                    Button {
                        isPresented = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .padding(.top,10)
                            .padding(.leading,10)
                    }
                    .alert("友達登録", isPresented: $isPresented) {
                        VStack {
                            TextField("名前", text: $nametext)
                            TextField("電話番号", text: $phonetext)
                        }
                        .font(.system(size: 15))
                        HStack {
                            Button {
                                // キャンセルボタンを押した場合、何もしない
                                isPresented = false
                                phonetext = ""
                                nametext = ""
                            } label: {
                                Text("キャンセル")
                            }
                            Button {
                                // 入力された電話番号と名前をUserDefaultsに保存
                                saveFriend(phone: phonetext, name: nametext)
                                isPresented = false
                                phonetext = ""
                                nametext = ""
                            } label: {
                                Text("OK")
                            }
                        }
                    }
                }
                .padding(.top,40)
                .padding(.leading,20)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                List {
                    ForEach(loadFriends(), id: \.self) { friend in
                        HStack {
                            Image(systemName: "person.fill")
                            Text(friend.name)
                                .padding(.bottom, 5)
                            Spacer()
                            Image(systemName: "phone.fill")
                            Text(friend.phoneNumber)
                                .padding(.bottom, 5)
                        }
                        .padding(5)
                        .swipeActions {
                                                    // 削除アクション
                                                    Button {
                                                        deleteFriend(at: IndexSet([loadFriends().firstIndex(where: { $0.id == friend.id })!]))
                                                    } label: {
                                                        Image(systemName: "trash.fill") // SFSymbolを使う
                                                            .foregroundColor(.white)
                                                    }
                                                    .tint(.red) // 削除ボタンの色を赤に設定
                                                }
                    }
                    
                    /*.onDelete(perform: deleteFriend)*/ // スワイプで削除
                }
                
            }
            .listStyle(.plain)
            .background(Color("pink3"))
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
    }
    
    // 友達を保存するメソッド
    private func saveFriend(phone: String, name: String) {
        var currentFriends = loadFriends()
        currentFriends.append(Friend(phoneNumber: phone, name: name))
        
        // 保存するデータをエンコード
        if let encoded = try? JSONEncoder().encode(currentFriends) {
            friendsData = encoded
        }
    }
    
    // 保存された友達データを読み込むメソッド
    private func loadFriends() -> [Friend] {
        if let decoded = try? JSONDecoder().decode([Friend].self, from: friendsData) {
            return decoded
        }
        return []
    }

    // 友達を削除するメソッド
    private func deleteFriend(at offsets: IndexSet) {
        var currentFriends = loadFriends()
        currentFriends.remove(atOffsets: offsets) // 指定された位置のアイテムを削除
        
        // 更新されたデータを再度保存
        if let encoded = try? JSONEncoder().encode(currentFriends) {
            friendsData = encoded
        }
    }
}

struct Friend: Identifiable, Codable, Hashable {
    var id = UUID()
    var phoneNumber: String
    var name: String
}

