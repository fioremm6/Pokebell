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
            HStack(spacing: 16) {
                ForEach(["pink3", "lightgray", "widgetblue"], id: \.self) { colorName in
                    Button(action: {
                        withAnimation {
                            selectedColor = colorName
                            appGroupUserDefaults.set(colorName, forKey: "WidgetColor")
                            refreshWidget()
                        }
                    }) {
                        ZStack {
                            Color(colorName)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                                
                            
                            // 選択されているときに二重の青いリングを表示
                            if selectedColor == colorName {
                                Circle()
                                    .stroke(Color.blue, lineWidth: 2)
                                    .frame(width: 48, height: 48)
                                
                                Circle()
                                    .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                                    .frame(width: 54, height: 54)
                            }
                        }
                    }
                }
            }
            .padding(.bottom, 330)
            
        }
    }
        
        private func refreshWidget() {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }


