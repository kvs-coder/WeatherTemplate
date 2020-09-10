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
    typealias Weather = ViewModel.Output
    var baseView: WeatherView!
    var viewModel: WeatherViewModel!

    private unowned var weatherImageView: UIImageView {
        return baseView.weatherImageView
    }
    private unowned var cityLabel: UILabel {
        return baseView.cityLabel
    }
    private unowned var dayLabel: UILabel {
        return baseView.dayLabel
    }
    private unowned var temperatureLabel: UILabel {
        return baseView.temperatureLabel
    }
    private let disposeBag = DisposeBag()
    private let weather = BehaviorRelay(value: Weather())

    override func loadView() {
        view = baseView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bindUI()
    }
    /// if user switched from dark mode to light
    /// need to color view again
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        view.adoptMode()
    }
}

extension WeatherViewController: ViewControllerProtocol {
    typealias View = WeatherView
    typealias ViewModel = WeatherViewModel
    typealias Controller = WeatherViewController

    static func make(
        baseView: WeatherView,
        viewModel: WeatherViewModel
    ) -> WeatherViewController {
        let weatherViewController = WeatherViewController()
        weatherViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString(
                "weatherView",
                comment: "the vc name"
            ),
            image: UIImage(named: "weather"),
            tag: 0
        )
        weatherViewController.baseView = baseView
        weatherViewController.viewModel = viewModel
        return weatherViewController
    }

    func bindUI() {
        viewModel.output.city
            .bind(to: cityLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.temperature
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.day
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.image
            .bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
    }
}
