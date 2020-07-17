//
//  ForecastViewController.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForecastViewController: UITableViewController {
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let networkService = NetworkService()
        networkService.requestForecast(latitude: 50.0, longitude: 50.0) { [weak self] forecastData, error in
            guard let this = self else {
                return
            }
            guard let data = forecastData, error == nil else {
                print(error!)
                return
            }
            this.tableView.delegate = nil
            this.tableView.dataSource = nil
            this.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            Observable
                .just(data.list)
                .bind(to: this.tableView.rx.items(
                    cellIdentifier: "cell",
                    cellType: UITableViewCell.self)
                ) { (row, element, cell) in
                    if let first = element.weather.first {
                        networkService.downloadImage(with: first.icon) { (image, _) in
                            cell.imageView?.image = image
                            cell.textLabel?.text = "\(element.main.temp) @ row \(Date(timeIntervalSince1970: element.dt))"
                        }
                    }
            }
            .disposed(by: this.disposeBag)
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
