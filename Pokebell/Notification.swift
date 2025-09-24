//
//  Notification.swift
//  Pokebell
//
//  Created by 菊地桃々 on 2025/06/04.
//

import Foundation
import UIKit
import FirebaseMessaging
import FirebaseCore
import WidgetKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
//        UIApplication.shared.registerForRemoteNotifications()
        application.registerForRemoteNotifications()
        
        Messaging.messaging().token { token, error in
            if let error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token {
                print("FCM registration token: \(token)")
            }
        }
        
        NotificationManager.shared.register()
        
        return true
    }
    
    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error \(error)")
    }
//    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        self.sendDeviceTokenToServer(data: deviceToken)
//    }
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let readableToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(readableToken)")
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let message = userInfo["message"] as? String,
           let sender  = userInfo["sender"] as? String {
            
            // App Groupsに保存
            let defaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")
            defaults?.set(message, forKey: "latestMessage")
            defaults?.set(sender, forKey: "latestSender")
            
            // Widget更新
            WidgetCenter.shared.reloadAllTimelines()
            
            // 音・バイブだけ鳴らす（ローカル通知）
            let content = UNMutableNotificationContent()
            content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "pager.caf"))
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(request)
        }
        
        completionHandler(.newData)
    }
    
    //    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    //        var readableToken = ""
    //        for index in 0 ..< deviceToken.count {
    //            readableToken += String(format: "%02.2hhx", deviceToken[index] as CVarArg)
    //        }
    //        print("Received an APNs device token: \(readableToken)")
    //    }
}

extension AppDelegate: MessagingDelegate {
    @objc func messaging(_: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase token: \(String(describing: fcmToken))")
    }
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // フォアグラウンド通知受信時（音だけ鳴らす）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // ポケベル風に音だけ → ロック画面には表示されない
        completionHandler([.sound])
    }
    
    // ユーザーが通知をタップした場合（今回はWidget更新には関係なし）
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    //extension AppDelegate: UNUserNotificationCenterDelegate {
    //    func userNotificationCenter(
    //        _: UNUserNotificationCenter,
    //        willPresent _: UNNotification,
    //        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    //    ) {
    //        completionHandler([.sound])
    //    }
    //
    //    func userNotificationCenter(
    //        _: UNUserNotificationCenter,
    //        didReceive response: UNNotificationResponse,
    //        withCompletionHandler completionHandler: @escaping () -> Void
    //    ) {
    //        let userInfo = response.notification.request.content.userInfo
    //        NotificationCenter.default.post(
    //            name: Notification.Name("didReceiveRemoteNotification"),
    //            object: nil,
    //            userInfo: userInfo
    //        )
    //        completionHandler()
    //    }
}
