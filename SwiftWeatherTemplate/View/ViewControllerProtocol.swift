//
//  ViewControllerProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    associatedtype Controller where Controller: UIViewController

    ///Factory method
    static func make() -> Controller
}
