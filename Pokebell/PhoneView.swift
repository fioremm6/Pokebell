//
//  PhoneView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/01/21.
//

import SwiftUI

struct PhoneView: View {
    @EnvironmentObject var messageModel: MessageModel
    @State private var currentInput: String = ""
    @State private var errorMessage: String? = nil
    
    var body: some View {
        VStack {
            Text("数字を入力してください")
                .font(.headline)
                .padding()
            
            Text("入力中: \(currentInput)")
                .font(.subheadline)
                .padding(.bottom)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(["1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"], id: \.self) { number in
                    Button(action: {
                        handleInput(number)
                        
                    }) {
                        Text(number)
                            .font(.title)
                            .frame(width: 70, height: 70)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(35)
                    }
                }
            }
            .padding()
            Button(action: resetInput) {
                            Text("リセット")
                                .font(.title2)
                                .frame(maxWidth: .infinity, minHeight: 50)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .padding([.leading, .trailing])
                        }
                        .padding(.bottom)
                        
            if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundColor(.red)
                                .padding(.bottom)
                        }
        }
        .padding()
    }
    
    private func handleInput(_ number: String) {
                   currentInput.append(number)
                   if  currentInput.hasSuffix("##") {
                       sendMessage()
                   }
               }
               
      
    private func sendMessage() {
        guard  currentInput.hasSuffix("##") else {
                   errorMessage = "正しい形式で入力してください:  ##"
                   return
               }
        Task {
            do {
                try await FirestoreClient.postMessage(text: currentInput, receiver: myNumber)
                currentInput = ""
                errorMessage = nil
            } catch {
                print(error.localizedDescription)
            }
        }
       
        
        
//               messageModel.messages.append(currentInput)
           }
    private func resetInput() {
            currentInput = ""
            errorMessage = nil
        }
    
}

#Preview {
    PhoneView()
}
