//
//  ForecastViewController.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

class ForecastViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.requestForecast(latitude: 50.0, longitude: 50.0) { [weak self] forecastData, error in
            guard let this = self, error == nil else {
                print(error!)
                return
            }
        }
    }
}

extension ForecastViewController: ViewControllerProtocol {
    static func make() -> ForecastViewController {
        let forecastViewController = ForecastViewController()
        forecastViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("forecastView", comment: "the vc name"),
            image: UIImage(named: "forecast"),
            tag: 1
        )
        return forecastViewController
    }
}
