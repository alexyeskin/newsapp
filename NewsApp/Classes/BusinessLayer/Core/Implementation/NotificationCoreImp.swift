//
//  NotificationCoreImp.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/26/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationCoreImp: NotificationCore {
    func registerNotifications(completion: @escaping (Result<Bool, NotificationError>) -> Void) {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        center.requestAuthorization(options: options) { success, error in
            guard error == nil else {
                completion(.failure(.registrationError))
                return
            }
            completion(.success(success))
        }
    }
    
    func sendNotification(completion: @escaping (NotificationError?) -> Void) {
        removeNotifications(withIdentifiers: ["Notification"])
        
        let date = Date(timeIntervalSinceNow: 5)
        
        let content = UNMutableNotificationContent()
        content.title = "New news available"
        content.body = "Check for new news"
        content.sound = .default
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.second], from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(identifier: "Notification", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        
        center.add(request) { error in
            guard error == nil else {
                completion(.sendingError)
                return
            }
        }
    }
    
    func removeNotifications(withIdentifiers identifiers: [String]) {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}
