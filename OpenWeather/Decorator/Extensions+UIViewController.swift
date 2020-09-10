//
//  Extensions+UIViewController.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 18.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

extension UIViewController {
    func makeNoConnectionAlert() -> UIAlertController {
        let alert = UIAlertController(
            title: NSLocalizedString(
                "alertNoConnectionHeader",
                comment: "alert's header"
            ),
            message: NSLocalizedString(
                "alertNoConnectionBody",
                comment: "alert's body"
            ),
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: .default,
                handler: nil
            )
        )
        return alert
    }
}
