//
//  WeatherViewController.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Network

class WeatherViewController: UIViewController {
    private let weatherView = WeatherView()
    private unowned var weatherImageView: UIImageView {
        return weatherView.weatherImageView
    }
    private unowned var cityLabel: UILabel {
        return weatherView.cityLabel
    }
    private unowned var dayLabel: UILabel {
        return weatherView.dayLabel
    }
    private unowned var temperatureLabel: UILabel {
        return weatherView.temperatureLabel
    }
    private let disposeBag = DisposeBag()
    let monitor = NWPathMonitor()

    override func loadView() {
        view = weatherView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        requestWeatherData { [weak self] (weatherData, image, error) in
            guard let this = self else {
                return
            }
            guard
                let data = weatherData,
                error == nil
                else {
                return
            }
            this.bindUI(with: data, image: image)
        }
    }

    private func requestWeatherData(
        completionHandler: @escaping (WeatherData?, UIImage?, Error?) -> Void
    ) {
        let networkService = NetworkService()
        networkService.requestWeather(
            latitude: 50.2,
            longitude: 50.2
        ) { weatherData, error in
            guard let data = weatherData, error == nil else {
                completionHandler(nil, nil, error)
                return
            }
            if let icon = data.weather.first?.icon {
                networkService.downloadImage(with: icon) { (cache, error) in
                    guard error == nil else {
                        logError(error!.localizedDescription)
                        return
                    }
                    completionHandler(data, cache, error)
                }
            } else {
                completionHandler(data, nil, error)
            }
        }
    }

    private func bindUI(with data: WeatherData, image: UIImage?) {
        Observable
            .just(data.dt)
            .map({ Date(timeIntervalSince1970: $0).formatted(with: Date.iso)})
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        Observable
            .just(data.name)
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        Observable
            .just(data.main.temp)
            .map({ "\(Int(round($0)).description)Cº" })
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        Observable.just(image)
            .bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
    }
}

extension WeatherViewController: ViewControllerProtocol {
    static func make() -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        weatherViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "weatherView",
                comment: "the vc name"
            ),
            image: UIImage(named: "weather"),
            tag: 0
        )
        return weatherViewController
    }
}
