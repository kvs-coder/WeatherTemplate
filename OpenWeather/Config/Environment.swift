//
//  Environment.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

final class Environment {
    enum Keys: String {
        case apiKey = "API_KEY"
        case apiUrl = "API_URL"
    }

    static let apiKey: String = {
        guard
            let apiKey = infoDictionary[Keys.apiKey.rawValue] as? String
            else {
                fatalError("API Key not set in plist for this environment")
        }
        return apiKey
    }()
    static let apiUrl: String = {
        guard
            let apiKey = infoDictionary[Keys.apiUrl.rawValue] as? String
            else {
                fatalError("API Url not set in plist for this environment")
        }
        return apiKey
    }()

    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()
}
