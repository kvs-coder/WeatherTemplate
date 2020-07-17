//
//  WeatherViewController.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    private let weatherView = WeatherView()

    override func loadView() {
        view = weatherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

extension WeatherViewController: ViewControllerProtocol {
    static func make() -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        weatherViewController.tabBarItem = UITabBarItem(
            tabBarSystemItem: .favorites,
            tag: 0
        )
        return weatherViewController
    }
}
