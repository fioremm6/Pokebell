//
//  NoticeView.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/06/11.
//

import SwiftUI

public final class NotificationManager {
    nonisolated(unsafe) public static let shared = NotificationManager()
    private init() {}

    /// 23:00 通知を登録
    public func register() {
        let center = UNUserNotificationCenter.current()

        // 1. 権限リクエスト
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            granted,
            _ in
            guard granted else { return }
            
            // 2. 既存(同ID)通知をリセット
            let id = "daily_23_notification"
            center.removePendingNotificationRequests(withIdentifiers: [id])
            
            // 3. 通知内容
            let content = UNMutableNotificationContent()
            content.title       = "✉️"
            content.body      = "届いたメッセージを確認してみましょう！"
            content.sound       = .default
            
            // 4. 23:00 毎日トリガ
            var date = DateComponents()
            date.weekday = 0
            date.hour   = 23
            date.minute = 0
            let trigger = UNCalendarNotificationTrigger(
                dateMatching: date,
                repeats: true
            )

            // 5. リクエスト登録
            let request = UNNotificationRequest(
                identifier: id,
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }
}
