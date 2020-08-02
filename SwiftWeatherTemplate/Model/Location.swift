//
//  Location.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 01.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Location: Codable {
    let latitude: Double
    let longitude: Double

    func toDictionary() -> [String: Double] {
        do {
            let encoded = try JSONEncoder().encode(self)
            guard
                let json = try JSON(data: encoded).dictionaryObject as? [String: Double]
                else {
                    return [:]
            }
            return json
        } catch {
            logError(error.localizedDescription)
        }
        return [:]
    }
}

extension Location: ParseProtocol {
    static func parse(from json: JSON) -> Location? {
        return Decoder().decode(from: json)
    }
}
