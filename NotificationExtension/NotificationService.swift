//
//  NotificationService.swift
//  NotificationExtension
//
//  Created by 菊地桃々 on 2025/09/23.
//

import UserNotifications
import WidgetKit



class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            bestAttemptContent.title = "\(bestAttemptContent.title) [modified]"
            let message = bestAttemptContent.userInfo["message"] as? String ?? "???"
            
            // 🔹 App Group経由で保存
            let sharedDefaults = UserDefaults(suiteName: "group.com.yourcompany.appname") // ←App Group名に変更
            sharedDefaults?.set(message, forKey: "latestMessage")
            sharedDefaults?.synchronize() // 念のため
            
            // 🔹 Widget更新トリガー
            WidgetCenter.shared.reloadAllTimelines()
            
            // 🔹 通知内容の変更も可能（省略可）
            bestAttemptContent.title = "新着メッセージ"
            bestAttemptContent.body = message
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}
