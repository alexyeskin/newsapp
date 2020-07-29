//
//  NotificationCore.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/26/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

protocol NotificationCore {
    func registerNotifications(completion: @escaping (Result<Bool, NotificationError>) -> Void)
    func sendNotification(completion: @escaping (NotificationError?) -> Void)
}
