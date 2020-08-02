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
import SwiftyJSON

class WeatherViewController: UIViewController {
    var weatherView: WeatherView!
    var viewModel: WeatherViewModel!

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

    override func loadView() {
        view = weatherView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated),
            name: NSNotification.Name.newLocationDetected,
            object: nil
        )
    }
    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.newLocationDetected,
            object: nil
        )
    }

    @objc func locationUpdated(_ notification: Notification) {
        guard let dictionary = notification.userInfo else {
            return
        }
        let json = JSON(dictionary)
        guard let location = Location.parse(from: json) else {
            return
        }
        viewModel.requestWeatherData(
            location: location,
            onOutputReceived: { [unowned self] output in
                self.dayLabel.text = output.day
                self.temperatureLabel.text = output.temperature
                self.cityLabel.text = output.city
            }, onImgaeDataReceived: { [unowned self] imageData in
                if let data = imageData {
                    self.weatherImageView.image = UIImage(data: data)
                }
        })
    }
}

extension WeatherViewController: ViewControllerProtocol {
    typealias View = WeatherView
    typealias ViewModel = WeatherViewModel
    typealias Controller = WeatherViewController

    static func make(view: WeatherView, viewModel: WeatherViewModel) -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        weatherViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "weatherView",
                comment: "the vc name"
            ),
            image: UIImage(named: "weather"),
            tag: 0
        )
        weatherViewController.weatherView = view
        weatherViewController.viewModel = viewModel
        return weatherViewController
    }
}
