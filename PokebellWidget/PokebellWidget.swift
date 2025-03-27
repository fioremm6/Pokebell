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
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        Task {
            let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(15 * 60)
            do {
                print(UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebell")?.string(forKey: "phoneNumber"))
                let phoneNumber: String = UserDefaultsKey[.phoneNumber] ?? ""
                let messages = try await FirestoreClient.fetchMessage(myNumber: phoneNumber)
                let latestMessage = messages[0]
                let entry = MessageEntry(sender: latestMessage.sender, message: latestMessage.text)
                let timeline = Timeline(
                    entries: [entry],
                    policy: .after(nextUpdateDate)
                )
                completion(timeline)
            } catch {
                let timeline = Timeline(
                    entries: [MessageEntry(sender: "メッセージの取得に失敗しました。", message: "")],
                    policy: .after(nextUpdateDate)
                )
                completion(timeline)
            }
        }
    }
}

struct MessageEntry: TimelineEntry {
    let date: Date = .now
    let sender: String
    let message: String
    
    static let placeholder = Self(sender: "", message: "")
    
}

struct PokebellWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            
            HStack {
                Text(entry.message)
                Text("-")
                Text(entry.sender)
            }
            .foregroundStyle(Color("gray"))
            .font(.custom("Dott-Font", size: 20))
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 30, trailing: 0))
        }
        .containerBackground(for: .widget) {
            Image("bell.bg")
                .resizable()
                .scaledToFill()
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

