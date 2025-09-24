//
//  PokebellWidget.swift
//  PokebellWidget
//
//  Created by 菊地桃々 on 2025/01/22.
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
//    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> ()) {
//            let latestMessage = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")?.string(forKey: "latestMessage") ?? "No message"
//            let latestSender  = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")?.string(forKey: "latestSender") ?? ""
//            
//            let entry = MessageEntry(sender: latestSender, message: latestMessage)
//            let timeline = Timeline(entries: [entry], policy: .after(.now.addingTimeInterval(60)))
//            completion(timeline)
//        }
    func getTimeline(in context: Context, completion: @escaping (Timeline<MessageEntry>) -> ()) {
        Task {
            let nextUpdate = Date().addingTimeInterval(900)
            do {
                let phoneNumber: String = UserDefaultsKey[.phoneNumber] ?? ""
                let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)

                if let latest = messages.first {
                    // 前回のメッセージと違うなら通知
                    let defaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")
                    let oldMessage = defaults?.string(forKey: "latestMessage")
                    if oldMessage != latest.text {
                        defaults?.set(latest.text, forKey: "latestMessage")
                        defaults?.set(latest.sender, forKey: "latestSender")

                        // 通知音
                        let content = UNMutableNotificationContent()
                        content.sound = UNNotificationSound(named: .init("pager.caf"))
                        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                        try await UNUserNotificationCenter.current().add(request)
                    }

                    let entry = MessageEntry(sender: latest.sender, message: latest.text)
                    completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
                    return
                }
            } catch {
                print("Error fetching messages: \(error)")
            }

            // fallback
            let entry = MessageEntry(sender: "", message: "No message")
            completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
        }
    }
//    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
//        Task {
//            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(15 * 60)
//            do {
//                
//                let phoneNumber: String = UserDefaultsKey[.phoneNumber] ?? ""
//                let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)
//                if messages.isEmpty {
//                throw NSError()
//                }
//
//                let latestMessage = messages[0]
//                let entry = MessageEntry(sender: latestMessage.sender, message: latestMessage.text)
//                let timeline = Timeline(
//                    entries: [entry],
//                    policy: .after(nextUpdateDate)
//                )
//                completion(timeline)
//            } catch {
//                let timeline = Timeline(
//                    entries: [MessageEntry(sender: "", message: "No meesage")],
//                    policy: .after(nextUpdateDate)
//                )
//                completion(timeline)
//            }
//        }
//    }
}

struct MessageEntry: TimelineEntry {
    let date: Date = .now
    let sender: String
    let message: String
    
    static let placeholder = Self(sender: "", message: "")
    
}
let appGroupUserDefaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")!

struct PokebellWidgetEntryView : View {
    var entry: Provider.Entry
    @State private var offset: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        VStack {
        }
        .containerBackground(for: .widget) {
            ZStack {
                Color("pink3")
                    .edgesIgnoringSafeArea(.all)
                let selectedColor = appGroupUserDefaults.string(forKey: "WidgetColor") ?? "pink3"
                                Color(selectedColor)
                                    .edgesIgnoringSafeArea(.all)
//                Image("hyougara.brown")
//                    .resizable()
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
                                    .font(.custom("x8y12pxTheStrongGamer", size: 20))
                                    .padding([.horizontal, .bottom], 4)
                                   
                                }
                            }
                                .padding([.horizontal, .top], 10)
                                .padding(.bottom, 10)
                            }
                            .padding([.horizontal, .top], 10)
                            .padding(.bottom, 60)
                    }
            }
        }
    }




    struct PokebellWidget: Widget {
        let kind: String = "PokebellWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                PokebellWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    
}

#Preview(as: .systemMedium) {
    PokebellWidget()
} timeline: {
    MessageEntry(sender: "1111", message: "222")
}
