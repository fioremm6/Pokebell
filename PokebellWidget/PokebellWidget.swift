//
//  PokebellWidget.swift
//  PokebellWidget
//
//  Created by 菊地桃々 on 2025/01/22.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), emoji: "😀")
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), emoji: "😀")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, emoji: "😀")
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let emoji: String
    
}

struct PokebellWidgetEntryView : View {
    var entry: Provider.Entry
    var newData: String
    
    var body: some View {
        VStack {
            ZStack {
                Image("bell.bg")
                    .resizable()
                    .scaledToFill()
                HStack {
                    Text(newData)
                        .foregroundStyle(Color("gray"))
                        .font(.custom("Dott-Font", size: 25))
                        .padding(EdgeInsets(top: 10, leading: 60, bottom: 40, trailing: 10))
                    Spacer()
                }
                    
            }
            

        }
//                VStack(spacing: 0) {
//                            // 上部のディスプレイ部分
//                            ZStack {
//                                // ディスプレイの背景
//                                Rectangle()
//                                    .fill(.green)
//                                    .frame(height: 60)
//                                    .cornerRadius(8) // 上部に角丸を適用
//        
//                                // テキスト表示
//                                Text("１２３４５")
//                                    .font(.custom("Dott-Font", size: 16))
//                                    .foregroundColor(.white)
//                                    .padding(.horizontal, 12)
//                                    .frame(maxWidth: .infinity, alignment: .leading)
//                            }
//                            .padding([.top, .leading, .trailing], 8)
//        
//                            // 本体部分
//                            ZStack {
//                                // 本体全体の背景
//                                RoundedRectangle(cornerRadius: 12)
//                                    .fill(
//                                        LinearGradient(
//                                            gradient: Gradient(colors: [Color.gray.opacity(0.9), Color.gray.opacity(0.7)]),
//                                            startPoint: .topLeading,
//                                            endPoint: .bottomTrailing
//                                        )
//                                    )
//                                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 3, y: 3)
//        
//                                // 右下の曲線のデザイン
//                                Path { path in
//                                    let width: CGFloat = 300 // 親ビュー幅（固定値を調整可能）
//                                    let height: CGFloat = 100
//                                    
//                                    path.move(to: CGPoint(x: 0, y: height)) // 左下から始まる
//                                    path.addLine(to: CGPoint(x: width * 0.6, y: height)) // 直線で右方向へ
//                                    path.addQuadCurve(
//                                        to: CGPoint(x: width, y: height * 0.6), // 曲線の終点
//                                        control: CGPoint(x: width * 0.8, y: height) // 制御点
//                                    )
//                                    path.addLine(to: CGPoint(x: width, y: 0)) // 上部へ
//                                    path.addLine(to: CGPoint(x: 0, y: 0)) // 左上まで直線
//                                    path.closeSubpath()
//                                }
//                                .fill(
//                                    LinearGradient(
//                                        gradient: Gradient(colors: [Color.gray.opacity(0.8), Color.gray.opacity(0.6)]),
//                                        startPoint: .top,
//                                        endPoint: .bottom
//                                    )
//                                )
//                            }
//                            .frame(height: 100) // 本体部分の高さ
//                        }
//                        .background(Color.purple.opacity(0.2)) // ウィジェット全体の背景
//                        .cornerRadius(12)
//                        .padding()
                    }
    }
    
    
    
    struct PokebellWidget: Widget {
        let kind: String = "PokebellWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: Provider()) { entry in
                if #available(iOS 17.0, *) {
                    PokebellWidgetEntryView(entry: entry, newData: "9999")
                        .containerBackground(.fill.tertiary, for: .widget)
                } else {
                    PokebellWidgetEntryView(entry: entry, newData: "66666")
                        .padding()
                        .background()
                }
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
        }
    }
    
    #Preview(as: .systemMedium) {
        PokebellWidget()
    } timeline: {
        SimpleEntry(date: .now, emoji: "😀")
        SimpleEntry(date: .now, emoji: "🤩")
    }

