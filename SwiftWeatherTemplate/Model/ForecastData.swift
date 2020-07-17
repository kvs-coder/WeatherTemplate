//
//  ForecastData.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import SwiftyJSON

struct ForecastData: Codable {
    let list: [WeatherData]
}

extension ForecastData: ParseProtocol {
    static func parse(from json: JSON) -> ForecastData? {
        let decoder = JSONDecoder()
        do {
            print(json)
            let rawData = try json.rawData()
            let forecastData = try decoder.decode(ForecastData.self, from: rawData)
            return forecastData
        } catch {
            print(error)
        }
        return nil
    }
}
