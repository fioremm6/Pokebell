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
                                
                                isHintPresented = false
                                hintnumbertext = ""
                                hintmeantext = ""
                            } label: {
                                Text("キャンセル")
                            }
                            Button {
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
                    HStack {
                        Text("0840")
                        Spacer()
                        Text("おはよう")
                    }
                    HStack {
                        Text("3476")
                        Spacer()
                        Text("さよなら")
                    }
                    HStack {
                        Text("0833")
                        Spacer()
                        Text("おやすみ")
                    }
                    HStack {
                        Text("999")
                        Spacer()
                        Text("サンキュー")
                    }
                    HStack {
                        Text("114106")
                        Spacer()
                        Text("あいしてる")
                    }
                    ForEach(loadHints(), id: \.self) { hint in
                        HStack {
                            Text(hint.number)
                                .padding(.bottom, 5)
                            Spacer()
                            Text(hint.mean)
                                .padding(.bottom, 5)
                        }
                        .padding(5)
                        .swipeActions {
                            
                            Button {
                                deleteHint(at: IndexSet([loadHints().firstIndex(where: { $0.id == hint.id })!]))
                            } label: {
                                Image(systemName: "trash.fill")
                                    .foregroundColor(.white)
                            }
                            .tint(.red)
                        }
                    }
                    
                    
                }
                
                
            }
            .listStyle(.plain)
            .background(Color("pink3"))
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
    }
    private func saveHint(phone: String, name: String) {
        var currentHints = loadHints()
        currentHints.append(Hint(number: hintnumbertext, mean: hintmeantext))
        if let encoded = try? JSONEncoder().encode(currentHints) {
            hintsData = encoded
        }
    }
    private func loadHints() -> [Hint] {
        if let decoded = try? JSONDecoder().decode([Hint].self, from: hintsData) {
            return decoded
        }
        return []
    }
    private func deleteHint(at offsets: IndexSet) {
        var currentHints = loadHints()
        currentHints.remove(atOffsets: offsets)
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


