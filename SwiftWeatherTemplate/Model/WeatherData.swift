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
    struct Main: Codable {
        let temp: Double
    }
    struct Weather: Codable {
        let main: String
        let icon: String
    }
    struct Coordinate: Codable {
        let lat: Double
        let lon: Double
    }
    struct City: Codable {
        let name: String?
    }

    let main: Main
    let dt: TimeInterval
    let coord: Coordinate?
    let weather: [Weather]
    let name: String?
    let city: City?
}

extension WeatherData: ParseProtocol {
    static func parse(from json: JSON) -> WeatherData? {
        print(json)
        return Decoder().decode(from: json)
    }
}
