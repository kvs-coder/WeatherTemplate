//
//  Extensions+TimeInterval.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 09.09.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

extension TimeInterval {
    var date: Date {
        return Date(timeIntervalSince1970: self)
    }
}
