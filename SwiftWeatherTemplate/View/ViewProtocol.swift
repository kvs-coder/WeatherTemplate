//
//  ViewProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 18.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation

protocol ViewProtocol {
    /// Every view should be constrained
    /// call this method directly in view's init()
    func makeConstraints()
}
