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
        monitorConnection()
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }

    private func requestWeatherData() {
        let networkService = NetworkService()
        networkService.requestWeather(
            latitude: 50.2,
            longitude: 50.2
        ) { [weak self] weatherData, error in
            guard let this = self, error == nil else {
                print(error!)
                return
            }
            guard let data = weatherData else {
                return
            }
            Observable
                .just(data.dt)
                .map({ Date(timeIntervalSince1970: $0).formatted(with: Date.iso)})
                .bind(to: this.dayLabel.rx.text)
                .disposed(by: this.disposeBag)
            Observable
                .just(data.name)
                .bind(to: this.cityLabel.rx.text)
                .disposed(by: this.disposeBag)
            Observable
                .just(data.main.temp)
                .map({ "\(Int(round($0)).description)Cº" })
                .bind(to: this.temperatureLabel.rx.text)
                .disposed(by: this.disposeBag)
            if let icon = data.weather.first?.icon {
                networkService.downloadImage(with: icon) { (cache, error) in
                    guard error == nil else {
                        print(error!)
                        return
                    }
                    Observable.just(cache)
                        .bind(to: this.weatherImageView.rx.image)
                        .disposed(by: this.disposeBag)
                }
            }
        }
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

    func monitorConnection() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.requestWeatherData()
            } else {
                self?.showNoConnectionAlert()
            }
        }
    }
}
