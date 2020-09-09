//
//  Extensions+UIView.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 09.09.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

extension UIView {
    func adoptMode() {
        let uiMode = traitCollection.userInterfaceStyle
        switch uiMode {
        case .dark:
            backgroundColor = .black
        default:
            backgroundColor = .white
        }
    }
}
