//
//  Decoder.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 18.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Decoder {
    func decode<T: Codable>(from json: JSON) -> T? {
        let decoder = JSONDecoder()
        do {
            let rawData = try json.rawData()
            let data = try decoder.decode(T.self, from: rawData)
            return data
        } catch {
            logError(error.localizedDescription)
        }
        return nil
    }
}
