//
//  ViewModelProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

protocol ViewModelProtocol {
    /// In order to make things more logic
    /// every event should be distinguished.
    /// **Input** for incoming events
    associatedtype Input
    /// **Output** for incoming events
    associatedtype Output

    var input: Input { get }
    var output: Output { get }

    /// Factory method to build ViewModel with service (Network so far)
    /// The ViewModel class should be **final**
    static func make(with service: NetworkService) -> Self
}
