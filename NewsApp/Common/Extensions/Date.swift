//
//  Date.swift
//  NewsApp
//
//  Created by Alexander Eskin on 12/13/19.
//  Copyright © 2019 PixelPlex. All rights reserved.
//

import Foundation

extension Date {
    func setDateFormat() -> String {
        var secondsAgo = Int(Date().timeIntervalSince(self))
        if secondsAgo < 0 {
            secondsAgo *= (-1)
        }
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute {
            if secondsAgo < 2 {
                return "just now"
            } else {
                return "\(secondsAgo)sec ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo / minute
            return "\(min)min ago"
        } else if secondsAgo < day {
            let hr = secondsAgo / hour
            return "\(hr)h ago"
        } else if secondsAgo < week {
            let day = secondsAgo / day
            return "\(day)d ago"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d, yyyy"
            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: self)
            return strDate
        }
    }
}
