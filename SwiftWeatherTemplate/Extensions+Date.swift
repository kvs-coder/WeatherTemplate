//
//  Extensions+Date.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 18.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

extension Date {
    static let iso = "MMM dd, yyyy HH:mm"

    func formatted(
        with format: String,
        timezone: TimeZone = TimeZone.current
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timezone
        let date = dateFormatter.string(from: self)
        return date
    }
}
