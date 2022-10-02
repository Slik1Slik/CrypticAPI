//
//  Date + Extensions.swift
//  Cryptic API
//
//  Created by Slik on 30.09.2022.
//

import Foundation

extension Date {
    
    func string(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = .current
        dateFormatter.timeZone = .current
        dateFormatter.locale = .current
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    init(from string: String) {
        let formatter = DateConstants.dateFormatter
        self = formatter.date(from: string) ?? Date()
    }
}
