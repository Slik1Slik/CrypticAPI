//
//  Date Constants.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

struct DateConstants {
    
    static let calendar: Calendar = getCalendar()
    static let dateFormatter = getDateFormatter()
    static let timeZone: TimeZone = TimeZone(secondsFromGMT: 0) ?? .current
    static let dateStyle: DateFormatter.Style = .short
    static let dayInSeconds = 86400
    
    private static func getDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = .short
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = timeZone
        
        return dateFormatter
    }
    
    private static func getCalendar() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        
        calendar.locale = Locale(identifier: "ru_RU")
        calendar.timeZone = DateConstants.timeZone
        
        return calendar
    }
}
