//
//  Extensions+UITableView.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 09.09.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

extension UITableView {
    func adoptBackgroundMode() {
        let view = UIView()
        view.adoptMode()
        self.backgroundView = view
    }
}
