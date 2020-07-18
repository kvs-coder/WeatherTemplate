//
//  WeatherData.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import SwiftyJSON

struct WeatherData: Codable {
    struct Weather: Codable {
        let icon: String
    }
    struct Main: Codable {
        let temp: Double
    }
    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }

    let main: Main
    let dt: TimeInterval
    let coord: Coordinate?
    let weather: [Weather]
    let name: String?
}

extension WeatherData: ParseProtocol {
    static func parse(from json: JSON) -> WeatherData? {
        print(json)
        return Decoder().decode(from: json)
    }
}
