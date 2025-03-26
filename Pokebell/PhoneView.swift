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
    @State private var myNumber: String = ""
    @FocusState private var isFocused: Bool
    
    @State var isRegistered = false

 
    var body: some View {
        ZStack {
            Image("pokebell.bc")
                .resizable()
                .ignoresSafeArea()
            HStack {
                VStack {
                    VStack {
                        VStack {
                            
                            Text(isRegistered ? "送り先の電話番号とメッセージを入力し、最後に＃＃をつけてください" : "電話番号を登録してください")
                            VStack {
                                HStack {
                                    Image(systemName: "phone.fill")
                                    Text(":")
                                    Text("\(phonenumInput)")
                                    Spacer()
                                }
                                HStack {
                                    Image(systemName: "envelope.fill")
                                    Text(":")
                                    Text("\(textnumInput)")
                                    Spacer()
                                }
                            }
                            .padding(EdgeInsets(top: 10, leading: 50, bottom: 0, trailing: 0))
                    
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 40, trailing: 20))
                    
                   
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
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
                       
                    }
                    .padding(EdgeInsets(top: 70, leading: 20, bottom: 20, trailing: 20))
                    HStack {
                        Button(action: deleteInput) {
                            Image(systemName: "delete.left")
                        }
                        Button(action: resetInput) {
                            Text("リセット")
                                .font(.title2)
                                .frame(maxWidth: .infinity, minHeight: 30)
                                .background(Color("gray"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding(EdgeInsets(top: 0, leading: 120, bottom: 20, trailing: 20))
                        }
                    }
                    .padding(.bottom)
                    
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
        Task {
            do {
                try await FirestoreClient.postMessage(text: textnumInput, receiver: phonenumInput,myNumber: myNumber)
                phonenumInput = ""
                textnumInput = ""
                errorMessage = nil
            } catch {
                print(error.localizedDescription)
            }
        }
       
        
        
//               messageModel.messages.append(currentInput)
           }
    private func deleteInput() {
        
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
