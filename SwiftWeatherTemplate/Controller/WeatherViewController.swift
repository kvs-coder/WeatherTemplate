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
    private unowned var weatherImageView: UIImageView {
        return weatherView.weatherImageView
    }

    override func loadView() {
        view = weatherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.requestWeather(
            latitude: 50.0,
            longitude: 50.0
        ) { [weak self] weatherData, error in
            guard let this = self, error == nil else {
                print(error!)
                return
            }
            guard let first = weatherData?.weather.first else {
                return
            }
//            networkService.downloadImage(with: first.icon) { (cache, error) in
//                guard error == nil else {
//                    print(error!)
//                    return
//                }
//                DispatchQueue.main.async {
//                    this.weatherImageView.image = cache//cache?.image(withIdentifier: id!)
//                }
//            }
        }
    }
}

extension WeatherViewController: ViewControllerProtocol {
    static func make() -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        weatherViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("weatherView", comment: "the vc name"),
            image: UIImage(named: "weather"),
            tag: 0
        )
        return weatherViewController
    }
}
