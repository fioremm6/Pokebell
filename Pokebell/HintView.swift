//
//  HintView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//


import SwiftUI
struct HintView: View {
    @EnvironmentObject var messageModel: MessageModel
   
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("084")
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
            }
            .listStyle(.plain)
            .navigationBarTitleTextColor(Color("blackgray"))
            .navigationTitle("Hints")
            .background(Color("pink3"))
            .foregroundColor(Color("blackgray"))
            .font(.custom("x8y12pxTheStrongGamer", size: 15))
        }
    }
       
       
}


