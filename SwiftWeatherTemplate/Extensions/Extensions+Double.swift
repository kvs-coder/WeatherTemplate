//
//  Extensions+Double.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 01.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

extension Double {
    func roundedToInt() -> Int {
        return Int(self.rounded())
    }
}
