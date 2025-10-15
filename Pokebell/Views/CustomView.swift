//
//  CustomView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/04/05.
//

import SwiftUI
import WidgetKit



struct CustomView: View {
    
    @State private var selectedColor: String = appGroupUserDefaults.string(forKey: "WidgetColor") ?? "pink3"
    @State private var selectedSticker: String = appGroupUserDefaults.string(forKey: "WidgetSticker") ?? "red.st"
    
    
    var body: some View {
        VStack {
            Text("Widget Custom")
                .font(.custom("x8y12pxTheStrongGamer", size: 30))
                .foregroundColor(Color("blackgray"))
                .padding(.top,130)
                .padding(.bottom,30)
            PokeSelectedColor(color: Color(selectedColor), image: Image(selectedSticker))
                .padding(20)
            
            
            Spacer()
            HStack(spacing: 16) {
                ForEach(["pink3", "pokegray", "widgetblue","widgetpurple","widgetblack"], id: \.self) { colorName in
                    Button {
                        let generator = UIImpactFeedbackGenerator(style: .soft)
                        generator.impactOccurred()
                        withAnimation {
                            selectedColor = colorName
                            appGroupUserDefaults.set(colorName, forKey: "WidgetColor")
                            refreshWidget()
                        }
                    } label: {
                        ZStack {
                            Color(colorName)
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                            
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
            Spacer()
            ScrollView (.horizontal) {
                HStack(spacing: 16) {
                    ForEach(["red.st", "blue.st", "yellow.st","green.st","pink.st","rainbow.st","gray.st","none.st"], id: \.self) { colorSticker in
                        Button {
                            let generator = UIImpactFeedbackGenerator(style: .soft)
                            generator.impactOccurred()
                            withAnimation {
                                selectedSticker = colorSticker
                                appGroupUserDefaults.set(colorSticker, forKey: "WidgetSticker")
                                refreshWidget()
                            }
                        } label: {
                            ZStack {
                                Image(colorSticker)
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .overlay {
                                        if colorSticker == "none.st" {
                                            Image(systemName: "circle.slash.fill")
                                        }
                                    }
                                
                                if selectedSticker == colorSticker {
                                    Circle()
                                        .stroke(Color.blue, lineWidth: 2)
                                        .frame(width: 70, height: 70)
                                    
                                    Circle()
                                        .stroke(Color.blue.opacity(0.6), lineWidth: 2)
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                    }
                }
                .padding(2)
            }
            .scrollIndicators(.visible)
            .padding(.horizontal,30)
            
            Spacer()
            Spacer()
            
//            .padding(.bottom,330)
            
            
        }
        .background(Color("gray"))
    }
    
    private func refreshWidget() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}


struct PokeSelectedColor: View {
    let color: Color
    let image: Image
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(color)
                .shadow(color: .gray.opacity(0.4), radius: 10, x: 0, y: 5)
                .overlay {
                    VStack {
                        PokeGreenBorder()
                        Spacer()
                    }
                }
                .frame(height: 170)
            image
                .resizable()
                .frame(width: 80, height: 80)
                .rotationEffect(.degrees(-10))
                .padding(.trailing, 200)
                .padding(.top,70)
            
        }
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
            .frame(height: 100)
    }
}

struct PokeGreenPart: View {
    var body: some View {
        ZStack {
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
                            Text("sample")
                        }
                        .foregroundStyle(Color("blackgray"))
                        .font(.custom("x8y12pxTheStrongGamer", size: 20))
                        .padding([.horizontal, .bottom], 4)
                        
                    }
                }
                .padding(10)
                .frame(height: 90)
        }
        
    }
}


#Preview {
    CustomView()
}
