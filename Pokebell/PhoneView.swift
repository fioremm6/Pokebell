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
    
    

 
    var body: some View {
        ZStack {
            Image("pokebell.bc")
                .resizable()
                .ignoresSafeArea()
            HStack {
                VStack {
                    VStack {
                        HStack {
                            Image(systemName: "phone.fill")
                            Text(":")
                            Text("\(phonenumInput)")
                                
                        }
                        //            TextField(text: $myNumber, prompt: Text("Number")){
                        //
                        //            }
                        //                .keyboardType(.numberPad)
                        
                        HStack {
                            Image(systemName: "envelope.fill")
                            Text(":")
                            Text("\(textnumInput)")
                                .font(.subheadline)
                        }
                    }
                    .padding(EdgeInsets(top: 120, leading: 120, bottom: 0, trailing: 20))
                    
                   
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
                                }
                            }
                       
                    }
                    .padding(EdgeInsets(top: 100, leading: 120, bottom: 50, trailing: 10))
                    Button(action: resetInput) {
                        Text("リセット")
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(Color("gray"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(EdgeInsets(top: 0, leading: 120, bottom: 20, trailing: 20))
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
