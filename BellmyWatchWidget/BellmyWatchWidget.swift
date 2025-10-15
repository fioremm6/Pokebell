//
//  BellmyWatchWidget.swift
//  BellmyWatchWidget
//
//  Created by 菊地桃々 on 2025/10/15.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MessageEntry {
        .placeholder
    }

    func getSnapshot(in context: Context, completion: @escaping (MessageEntry) -> ()) {
        completion(.placeholder)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(15*60)
            let phoneNumber: String = UserDefaultsKey2[.phoneNumber] ?? ""
            let message: String = UserDefaultsKey2[.saishinMessage] ?? ""
            let entry = MessageEntry(sender: "", message: message)
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }

//    func relevances() async -> WidgetRelevances<Void> {
//        // Generate a list containing the contexts this widget is relevant in.
//    }
}

struct MessageEntry: TimelineEntry {
    let date: Date = .now
    let sender: String
    let message: String
    static let placeholder = Self(sender: "jhjhjh", message: "66666")
}

struct BellmyWatchWidgetEntryView : View {
    var entry: Provider.Entry
    
    let appGroupUserDefaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")!

    var body: some View {
        VStack {
            Text(entry.message)
                .font(.custom("x8y12pxTheStrongGamer", size: 20))
            ZStack {
                Color("pink3")
                    .edgesIgnoringSafeArea(.all)
                let selectedColor = appGroupUserDefaults.string(forKey: "WidgetColor") ?? "pink3"
                let selectedSticker = appGroupUserDefaults.string(forKey: "WidgetSticker") ?? "red.st"
                Color(selectedColor)
                    .edgesIgnoringSafeArea(.all)
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
                                            Text(entry.message)
                                            Text("-")
                                            Text(entry.sender)
                                            
                                        }
                                        .foregroundStyle(Color("blackgray"))
                                        .font(.system(size: 5))
//                                        .font(.custom("x8y12pxTheStrongGamer", size: 20))
                                        .padding([.horizontal, .bottom], 4)
                                        
                                    }
                                }
                                .padding([.horizontal, .top], 10)
                                .padding(.bottom, 10)
                        }
                        .padding([.horizontal, .top], 10)
                        .padding(.bottom, 60)
                Image(selectedSticker)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-10))
                    .padding(.trailing, 200)
                    .padding(.top,70)
                   
            
            }
            .scaleEffect(0.68)
            .offset(y: 5)
        }
    }
}

@main
struct BellmyWatchWidget: Widget {
    let kind: String = "BellmyWatchWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(watchOS 10.0, *) {
                BellmyWatchWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BellmyWatchWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
//let appGroupUserDefaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")!
//
//struct PokebellWidgetEntryView : View {
//    var entry: Provider.Entry
//    
//    var body: some View {
       
//    }
//}
//
//
//
//
//struct PokebellWidget: Widget {
//    let kind: String = "PokebellWidget"
//    
//    var body: some WidgetConfiguration {
//        StaticConfiguration(kind: kind, provider: Provider()) { entry in
//            PokebellWidgetEntryView(entry: entry)
//        }
//        .configurationDisplayName("My Widget")
//        .description("This is an example widget.")
//    }
//    
//}
