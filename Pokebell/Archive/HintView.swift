//
//  HintView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//


import SwiftUI
struct HintView: View {
    @EnvironmentObject var messageModel: MessageModel
    @AppStorage("number", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var number = ""
    @AppStorage("mean", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var mean = ""
    @State private var isHintPresented = false
    @State private var hintnumbertext = ""
    @State private var hintmeantext = ""
    
    // UserDefaultsから電話番号と名前を配列で読み込む
    @AppStorage("hints", store: UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) private var hintsData: Data = Data()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Hints")
                        .font(.custom("x8y12pxTheStrongGamer", size: 30))
                    Button {
                        isHintPresented = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .padding(.top,10)
                            .padding(.leading,10)
                    }
                    .alert("暗号登録", isPresented: $isHintPresented) {
                        VStack {
                            TextField("番号", text: $hintnumbertext)
                            TextField("意味", text: $hintmeantext)
                        }
                        .font(.system(size: 15))
                        HStack {
                            Button {
                                // キャンセルボタンを押した場合、何もしない
                                isHintPresented = false
                                hintnumbertext = ""
                                hintmeantext = ""
                            } label: {
                                Text("キャンセル")
                            }
                            Button {
                                // 入力された電話番号と名前をUserDefaultsに保存
                                saveHint(phone: hintnumbertext, name: hintmeantext)
                                isHintPresented = false
                                hintnumbertext = ""
                                hintmeantext = ""
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
                    ForEach(loadHints(), id: \.self) { hint in
                        HStack {
//                            Image(systemName: "person.fill")
                            Text(hint.number)
                                .padding(.bottom, 5)
                            Spacer()
//                            Image(systemName: "phone.fill")
                            Text(hint.mean)
                                .padding(.bottom, 5)
                        }
                        .padding(5)
                        .swipeActions {
                                                    // 削除アクション
                                                    Button {
                                                        deleteHint(at: IndexSet([loadHints().firstIndex(where: { $0.id == hint.id })!]))
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
    private func saveHint(phone: String, name: String) {
        var currentHints = loadHints()
        currentHints.append(Hint(number: hintnumbertext, mean: hintmeantext))
        
        // 保存するデータをエンコード
        if let encoded = try? JSONEncoder().encode(currentHints) {
            hintsData = encoded
        }
    }
    
    // 保存された友達データを読み込むメソッド
    private func loadHints() -> [Hint] {
        if let decoded = try? JSONDecoder().decode([Hint].self, from: hintsData) {
            return decoded
        }
        return []
    }

    // 友達を削除するメソッド
    private func deleteHint(at offsets: IndexSet) {
        var currentHints = loadHints()
        currentHints.remove(atOffsets: offsets) // 指定された位置のアイテムを削除
        
        // 更新されたデータを再度保存
        if let encoded = try? JSONEncoder().encode(currentHints) {
            hintsData = encoded
        }
    }
}

struct Hint: Identifiable, Codable, Hashable {
    var id = UUID()
    var number: String
    var mean: String
}


//            List {
//                HStack {
//                    Text("084")
//                    Spacer()
//                    Text("おはよう")
//                }
//                HStack {
//                    Text("3476")
//                    Spacer()
//                    Text("さよなら")
//                }
//                HStack {
//                    Text("0833")
//                    Spacer()
//                    Text("おやすみ")
//                }
//                HStack {
//                    Text("999")
//                    Spacer()
//                    Text("サンキュー")
//                }
//                HStack {
//                    Text("114106")
//                    Spacer()
//                    Text("あいしてる")
//                }
//            }
           
           
