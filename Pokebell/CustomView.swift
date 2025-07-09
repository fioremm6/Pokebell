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
                .foregroundColor(Color("blackgray"))
                .padding(.top,100)
                .padding(.bottom,30)
            PokeSelectedColor(color: Color(selectedColor))
                .padding(20)
            
            
            Spacer()
            HStack(spacing: 16) {
                ForEach(["pink3", "pokegray", "widgetblue","widgetpurple","widgetblack"], id: \.self) { colorName in
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
            .padding(.bottom,330)
           
            
        }
    }
    
    private func refreshWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}

struct PokeSelectedColor: View {
    let color: Color
    var body: some View {
        RoundedRectangle(cornerRadius: 25)
            .fill(color)
            .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
            .overlay {
                VStack {
                    PokeGreenBorder()
                    Spacer()
                }
            }
            .frame(height: 190)
    }
}

struct PokeGreenBorder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("blackgray"))
            .overlay {
                PokeGreenPart()
            }
            .padding(.horizontal, 10)
            .padding(.top,10)
            .frame(height: 110)
    }
}

struct PokeGreenPart: View {
    var body: some View {
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
            .frame(height: 100)
    }
}

#Preview {
    CustomView()
}
