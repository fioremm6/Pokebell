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
    @State var isShowingAddressView = false
    @State var isShowingHintView = false
    @Environment(\.modelContext) private var context
    
    @AppStorage(UserDefaultsKey.phoneNumber.rawValue, store: .init(suiteName: "group.app.kikuchi.momorin.Pokebellmy")) var phoneNumber = ""
    
    var phoneSection: some View {
        HStack {
            Button {
                isShowingAddressView = true
            } label: {
                Image(systemName: "phone.fill")
                    .foregroundColor(Color("blackgray"))
                //                                                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.top,5)
            }
            .sheet(isPresented: $isShowingAddressView) {
                AddressView(phoneNumInput: $phonenumInput)
            }
            
            Text(":")
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            Text("\(phonenumInput)")
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            Spacer()
        }
    }
    
    var textSection: some View {
        HStack {
            Button {
                isShowingHintView = true
            } label: {
                Image(systemName: "envelope.fill")
                    .foregroundColor(Color("blackgray"))
                    .scaledToFit()
                    .frame(width: 20)
                    .padding(.top,5)
            }
            .sheet(isPresented: $isShowingHintView) {
               HintView()
            }
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
            VStack {
               
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
                                Button(action: {
                                    handleInput(number)
                                    
                                }) {
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
                            Button(action: resetInput) {
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(Color("blackgray"))
                                    .frame(width: 60, height: 60)
                                    .background(Color("lightgray"))
                                    .cornerRadius(35)
                                    .shadow(color: Color("pokepink"),radius: 5)
                                
                            }
                            Button(action: resetInput) { //使わない
                                Image(systemName: "arrow.clockwise")
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(Color("lightpink"))
                                    .cornerRadius(35)
                                    .shadow(radius: 5)
                                
                            }
                            .opacity(0)
                            Button(action: deleteInput) {
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
                    let data = PokebellUser(phoneNumber: phonenumInput, textNum: String(textnumInput.dropLast(2)))
                    context.insert(data)
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
