//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI
import WhatsNewKit
import TipKit

//struct HashTagPostButtonTip: Tip {
//    var image: Image? {
//        Image(systemName: "star.bubble")
//    }
//    var title: Text {
//        Text("自分の電話番号を入力してください。最後に＃を２回押して登録完了です！")
//    }
//    var message: Text? {
//        Text("Double-tap a message, then choose a Tapback, like a ♥︎.")
//    }
    
    
//}

struct PhoneView: View {
    
//    var hashtagButtonTip = HashTagPostButtonTip()
    
    @EnvironmentObject var messageModel: MessageModel
    @State private var phonenumInput: String = ""
    @State private var textnumInput: String = ""
    @State private var errorMessage: String? = nil
    @FocusState private var isFocused: Bool
    @State var isShowingAddressView = false
    @State var isShowingHintView = false
    @State private var isWhatsNewPresented = false
    
    
    
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    
    @State var whatsNew: WhatsNew? = WhatsNew(
            title: "Bellmyの使い方",
            features: [
                .init(
                    image: .init(
                        systemName: "phone.fill",
                        foregroundColor: Color("blackgray")
                    ),
                    title: "自分の電話番号を登録しよう。",
                    subtitle: "初めに自分の電話番号を登録します。自分の電話番号11桁を入力して、最後に＃を２回押して設定完了です。"
                ),
                .init(
                    image: .init(
                        systemName: "envelope.fill",
                        foregroundColor: Color("blackgray")
                    ),
                    title: "メッセージを送ってみよう。",
                    subtitle: "送りたい相手の電話番号11桁を入力します。次に送りたいメッセージを入力し、最後に＃を２回押して送信完了です。"
                
                ),
                .init(
                    image: .init(
                        systemName: "widget.small.badge.plus",
                        foregroundColor: Color("blackgray")
                    ),
                    title: "ホーム画面のウィジェットを追加しよう。",
                    subtitle: "ポケベルの色はアプリ内で変えることができます。"
                
                ),
                .init(
                    image: .init(
                        systemName: "questionmark.bubble",
                        foregroundColor: Color("blackgray")
                    ),
                    title: "＃＃の秘密",
                    subtitle: "公衆電話からポケベルにメッセージを送っていた時代、最後に＃＃をつけることでメッセージを送ることができました。このアプリではそこまで再現しています！"
                
                )
                // ...
            ]
        )

    var phoneSection: some View {
        HStack {
//            Button {
//                isShowingAddressView = false
//            } label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(Color("blackgray"))
                //                                                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.top,5)
//            }
//            .sheet(isPresented: $isShowingAddressView) {
//                //AddressView(phoneNumInput: $phonenumInput)
//            }
            
            Text(":")
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
//                .popoverTip(hashtagButtonTip)
            Text("\(phonenumInput)")
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            Spacer()
        }
    }
    
    var textSection: some View {
        HStack {
//            Button {
//                isShowingHintView = false
//            } label: {
                Image(systemName: "envelope.fill")
                .foregroundColor(Color("blackgray"))
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.top,5)
//            }
//            .sheet(isPresented: $isShowingHintView) {
//               //HintView()
//            }
            Text(":")
                .foregroundColor(Color("blackgray"))
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            Text("\(textnumInput)")
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            Spacer()
        }
    }
    
    var body: some View {
        ZStack {
            Color("pink3")
                .edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                Button {
                    isWhatsNewPresented = true
                } label: {
                    Image(systemName: "questionmark.circle")
                        .foregroundColor(Color("blackgray"))
                        .font(.system(size: 25))
                        .padding(.bottom,650)
                        .padding(.horizontal,20)
                }
            }
            .sheet(isPresented: $isWhatsNewPresented) {
                    // WhatsNew画面を表示
                    WhatsNewView(whatsNew: whatsNew!)
                }
            VStack {
////                Button {
////                   
////                            } label: {
//                                Text("119")
//                                    .foregroundColor(Color("blackgray"))
//                                    .font(.custom("x8y12pxTheStrongGamer", size: 20))
////                            }
////                            .sheet(whatsNew: self.$whatsNew)
//                            
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color("blackgray"))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("pokegreen"))
                                .overlay {
                                    VStack {
                                        Text(phoneNumber.isEmpty ? "set your phone number + 「##」" : "phone number & message + 「##」")
                                            .minimumScaleFactor(0.7)
                                            .foregroundColor(Color("blackgray"))
                                            .font(.custom("x8y12pxTheStrongGamer", size: 20))
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundStyle(Color("blackgray"))
                                        VStack {
                                           phoneSection
                                            textSection
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                                        .foregroundColor(Color("blackgray"))
                                        
                                    }
                                    .padding(8)
                                }
                                .padding(14)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 70)
                }
                HStack {
                    VStack {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"], id: \.self) { number in
                                Button {
                                    handleInput(number)
                                    let generator = UIImpactFeedbackGenerator(style: .heavy)
                                    generator.impactOccurred()
                                    
                                } label: {
                                    Text(number)
                                        .font(.custom("x8y12pxTheStrongGamer", size: 25))
                                        .padding(.bottom,7)
                                        .foregroundColor(Color("blackgray"))
                                        .frame(width: 60, height: 60)
                                        .background(Color("lightgray"))
                                        .cornerRadius(35)
                                        .shadow(color: Color("pokepink"),radius: 5)
                                }
                            }
                            Button {
                                resetInput()
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(Color("blackgray"))
                                    .frame(width: 60, height: 60)
                                    .background(Color("lightgray"))
                                    .cornerRadius(35)
                                    .shadow(color: Color("pokepink"),radius: 5)
                                
                            }
                            Button {
                                resetInput()
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                            } label: {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color("lightpink"))
                                    .cornerRadius(35)
                                    .shadow(radius: 5)
                                
                            }
                            .opacity(0)
                            Button {
                                deleteInput()
                                let generator = UIImpactFeedbackGenerator(style: .heavy)
                                generator.impactOccurred()
                            } label: {
                                Image(systemName: "delete.left")
                                    .foregroundColor(Color("blackgray"))
                                    .frame(width: 60, height: 60)
                                    .background(Color("lightgray"))
                                    .cornerRadius(35)
                                    .shadow(color:Color("pokepink"),radius: 5)
                                
                            }
                            
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                        
                        
                        if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom)
                        }
                        
                    }
                    
                }
                .padding()
            }
        }
        .sheet(whatsNew: self.$whatsNew)
        .task {
            try? Tips.configure([
                .displayFrequency(.immediate),
                .datastoreLocation(.applicationDefault)
            ])
        }
    }
    
    
    
    private func handleInput(_ number: String) {
        //        guard let UserDefaults(suiteName: "group.Pokebell")?.object(forKey: "number")
        
        if phonenumInput.count >= 11 {
            textnumInput.append(number)
        } else {
            phonenumInput.append(number)
        }
        if  textnumInput.hasSuffix("##") {
            sendMessage()
        }
    }
    
    
    private func sendMessage() {
        guard  textnumInput.hasSuffix("##") else {
            errorMessage = "正しい形式で入力してください:  ##"
            return
        }
        if phoneNumber.isEmpty {
            phoneNumber = phonenumInput
            phonenumInput = ""
            textnumInput = ""
            
        } else {
            //
            Task {
                do {
                    
                    try await FirestoreClient.postMessage(text: String(textnumInput.dropLast(2)),receiver: phonenumInput,myNumber: phoneNumber)
                    phonenumInput = ""
                    textnumInput = ""
                    errorMessage = nil
                   
                } catch {
                    print(error.localizedDescription)
                }
            }
        
        }
        
        
        
        //               messageModel.messages.append(currentInput)
    }
    
    private func deleteInput() {
        if phonenumInput.count >= 11 {
            textnumInput = String(textnumInput.dropLast())
        }else {
            phonenumInput = String(phonenumInput.dropLast())
        }
    }
    
    private func resetInput() {
        phonenumInput = ""
        textnumInput = ""
        errorMessage = nil
    }
    private func sendMynumber() {
        textnumInput = ""
        errorMessage = nil
    }
    private func showHint() {
        
    }
    private func showAddress() {
        
    }
    
}

#Preview {
    PhoneView()
}
