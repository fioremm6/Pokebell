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
import AudioToolbox

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: { _, _ in })
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
    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let readableToken = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNs device token: \(readableToken)")
    }
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if let message = userInfo["message"] as? String,
           let sender  = userInfo["sender"] as? String {
            let defaults = UserDefaults(suiteName: "group.app.kikuchi.momorin.Pokebellmy")
            let oldMessage = defaults?.string(forKey: "latestMessage")
            defaults?.set(message, forKey: "latestMessage")
            defaults?.set(sender, forKey: "latestSender")
            
            WidgetCenter.shared.reloadAllTimelines()
            if oldMessage != message {
                let content = UNMutableNotificationContent()
                content.title = sender
                content.body = message
                content.sound = UNNotificationSound(named: UNNotificationSoundName("sound.caf"))
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
                UNUserNotificationCenter.current().add(request)
            }
            
            completionHandler(.newData)
        }
    }
}
extension AppDelegate: MessagingDelegate {
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        completionHandler([.alert, .sound, .badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
