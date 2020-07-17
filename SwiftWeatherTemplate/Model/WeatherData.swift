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
        let icon: String
    }

    let main: Main
    let dt: TimeInterval
    let weather: [Weather]
}

extension WeatherData: ParseProtocol {
    static func parse(from json: JSON) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            let rawData = try json.rawData()
            let weatherData = try decoder.decode(WeatherData.self, from: rawData)
            return weatherData
        } catch {
            print(error)
        }
        return nil
    }
}
