//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI

struct PhoneView: View {
    @EnvironmentObject var messageModel: MessageModel
    @State private var phonenumInput: String = ""
    @State private var textnumInput: String = ""
    @State private var errorMessage: String? = nil
    @FocusState private var isFocused: Bool
    
    @State var isRegistered = false
    
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebell")) var phoneNumber = ""
    
    
    var body: some View {
        ZStack {
            Color.gray.opacity(0.8)
                .edgesIgnoringSafeArea(.all)
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color.black.opacity(0.8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.green)
                                .overlay {
                                    VStack {
                                        Text(phoneNumber.isEmpty ? "自分の電話番号が登録されていません。電話番号を入力し、最後に＃＃をつけてください。" : "送り先の電話番号とメッセージを入力し、最後に＃＃をつけてください")
                                            .minimumScaleFactor(0.7)
                                        VStack {
                                            HStack {
                                                Image(systemName: "phone.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                Text(":")
                                                Text("\(phonenumInput)")
                                                Spacer()
                                            }
                                            HStack {
                                                Image(systemName: "envelope.fill")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 20)
                                                Text(":")
                                                Text("\(textnumInput)")
                                                Spacer()
                                            }
                                        }
                                        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                                        
                                    }
                                    .padding(8)
                                }
                                .padding(14)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 40)
                }
                HStack {
                    VStack {
                        VStack {
                            //                        VStack {
                            //                            Text(phoneNumber.isEmpty ? "自分の電話番号が登録されていません。電話番号を入力し、最後に＃＃をつけてください。" : "送り先の電話番号とメッセージを入力し、最後に＃＃をつけてください")
                            //                            VStack {
                            //                                HStack {
                            //                                    Image(systemName: "phone.fill")
                            //                                    Text(":")
                            //                                    Text("\(phonenumInput)")
                            //                                    Spacer()
                            //                                }
                            //                                HStack {
                            //                                    Image(systemName: "envelope.fill")
                            //                                    Text(":")
                            //                                    Text("\(textnumInput)")
                            //                                    Spacer()
                            //                                }
                            //                            }
                            //                            .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
                            //
                            //                        }
                        }
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 30, trailing: 30))
                        
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 20) {
                            ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"], id: \.self) { number in
                                Button(action: {
                                    handleInput(number)
                                    
                                }) {
                                    Text(number)
                                        .foregroundColor(.white)
                                        .frame(width: 60, height: 60)
                                        .background(Color("gray"))
                                        .cornerRadius(35)
                                        .shadow(radius: 5)
                                }
                            }
                            Button(action: resetInput) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color("gray"))
                                    .cornerRadius(35)
                                    .shadow(radius: 5)
                                //                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 20))
                            }
                            Button(action: resetInput) { //使わない
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color("gray"))
                                    .cornerRadius(35)
                                    .shadow(radius: 5)
                                //                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 20))
                            }
                            .opacity(0)
                            Button(action: deleteInput) {
                                Image(systemName: "delete.left")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color("gray"))
                                    .cornerRadius(35)
                                    .shadow(radius: 5)
                                //                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 20))
                            }
                            
                        }
                        .padding(EdgeInsets(top: 30, leading: 20, bottom: 20, trailing: 20))
                        //                    HStack {
                        //
                        //                        Button(action: resetInput) {
                        //                            Text("リセット")
                        //                                .foregroundColor(.white)
                        //                                .frame(width: 60, height: 60)
                        //                                .background(Color("gray"))
                        //                                .cornerRadius(35)
                        //                                .shadow(radius: 5)
                        //                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 20))
                        //                        }
                        //                        Button(action: deleteInput) {
                        //                            Image(systemName: "delete.left")
                        //                                .frame(maxWidth: .infinity, minHeight: 30)
                        //                                .background(Color("gray"))
                        //                                .foregroundColor(.white)
                        //                                .cornerRadius(15)
                        //                                .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 20))
                        //                        }
                        //                    }
                        //                    .padding(.bottom)
                        
                        
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
                    try await FirestoreClient.postMessage(text: String(textnumInput.dropLast(2)), receiver: phonenumInput,myNumber: phoneNumber)
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
    
}

#Preview {
    PhoneView()
}
