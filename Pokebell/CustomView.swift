//
//  CustomView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI
import WidgetKit



struct CustomView: View {
    // ユーザーが選択した色を保持
    @State private var selectedColor: String = appGroupUserDefaults.string(forKey: "WidgetColor") ?? "pink3"


    var body: some View {
        VStack {
            Text("Widget Custom")
                .font(.custom("x8y12pxTheStrongGamer", size: 30))
                .padding(.top,100)
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(selectedColor))
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("blackgray"))
                            .overlay {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color("pokegreen"))
                                    .overlay {
                                        VStack {
                                            HStack {
                                                Image(systemName: "antenna.radiowaves.left.and.right")
                                                Image(systemName: "bell.fill")
                                                Spacer()
                                                Image(systemName: "speaker.wave.3.fill")
                                                Image(systemName: "music.note")
                                                
                                            }
                                            .font(.system(size: 15))
                                            .foregroundColor(Color("blackgray"))
                                            .padding(.horizontal, 15)
                                            HStack {
                                                //                                    Text(entry.message)
                                                Text("sample")
                                                //                                    Text(entry.sender)
                                                
                                            }
                                            .foregroundStyle(Color("blackgray"))
                                            .font(.custom("x8y12pxTheStrongGamer", size: 20))
                                            .padding([.horizontal, .bottom], 4)
                                            
                                        }
                                    }
                                    .padding(10)
                            }
                            .padding(.horizontal, 10)
                            .padding(.top,10)
                            .padding(.bottom, 60)
                    }
                    .padding(.horizontal, 30)
                    .padding(.top, 30)
                    .padding(.bottom,20)
                
                
            }
            HStack {
                Button(action: {
                    selectedColor = "pink3"
                    appGroupUserDefaults.set("pink3", forKey: "WidgetColor")
                    refreshWidget()
                    
                }) {
                    Color("pink3")
                        .frame(width: 40,height: 40)
                        .cornerRadius(20)
                        .overlay{
                                        Circle()                                // 円形部品
                                            .stroke(Color.black, lineWidth: 1)  // 白い輪郭
                                            .shadow(radius:1)                   // 影を付ける
                                    }

                }
                Button(action: {
                    selectedColor = "lightgray"
                    appGroupUserDefaults.set("lightgray", forKey: "WidgetColor")
                    refreshWidget()
                    
                }) {
                    
                    Color("lightgray")
                        .frame(width: 40,height: 40)
                        .cornerRadius(20)
                        .overlay{
                            Circle()                                // 円形部品
                                .stroke(Color.black, lineWidth: 1)  // 白い輪郭
                                .shadow(radius:1)                   // 影を付ける
                        }
                       
                }
                .padding(.horizontal,5)
                    Button(action: {
                        selectedColor = "widgetblue"
                        appGroupUserDefaults.set("widgetblue", forKey: "WidgetColor")
                        refreshWidget()
                        
                    }) {
                        Color("widgetblue")
                            .frame(width: 40,height: 40)
                            .cornerRadius(20)
                            .overlay{
                                            Circle()                                // 円形部品
                                                .stroke(Color.black, lineWidth: 1)  // 白い輪郭
                                                .shadow(radius:1)                   // 影を付ける
                                        }
                            

                    }
                    
                }
                .padding(.bottom,330)
            }
        .foregroundColor(Color("blackgray"))
        }
    
    private func refreshWidget() {
            WidgetCenter.shared.reloadAllTimelines()
        }
}

