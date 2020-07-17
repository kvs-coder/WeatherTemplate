//
//  Weather.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

struct Weather {
    let temperature: Int
    let condition: Int
    let conditionDescription: String
    let cityName: String
    let longitude: Double
    let latitude: Double
    let timestamp: Int
    var iconName: String {
        switch (condition) {
        case 0...300 :
            return "tstorm1@2x"
        case 301...500 :
            return "lightrain@2x"
        case 501...600 :
            return "shower3@2x"
        case 601...700 :
            return "snow4@2x"
        case 701...771 :
            return "fog@2x"
        case 772...800 :
            return "tstorm3@2x"
        case 800 :
            return "sunny@2x"
        case 801...804 :
            return "cloudy2@2x"
        case 900...903, 905...1000 :
            return "tstorm3@2x"
        case 903 :
            return "snow5@2x"
        case 904 :
            return "sunny@2x"
        default :
            return "dunno@2x"
        }
    }
}
