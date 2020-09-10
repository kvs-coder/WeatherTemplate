//
//  ParseProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol ParseProtocol {
    associatedtype Parseble where Parseble: Codable

    static func parse(from json: JSON) -> Parseble?
}
