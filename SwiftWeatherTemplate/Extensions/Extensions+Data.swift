//
//  Extensions+Data.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

extension Data {
    var asImage: UIImage? {
        return UIImage(data: self)
    }
}
