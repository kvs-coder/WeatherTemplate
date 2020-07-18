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

class ForecastViewController: UIViewController {
    typealias Cell = UITableViewCell

    private let forecastView = ForecastView()
    private unowned var tableView: UITableView {
        return forecastView.tableView
    }
    private let cellId = "cell"
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = forecastView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        let networkService = NetworkService()
        networkService.requestForecast(
            latitude: 50.2,
            longitude: 50.2
        ) { [weak self] forecastData, error in
            guard let this = self else {
                return
            }
            guard
                let data = forecastData,
                error == nil
                else {
                    print(error!)
                    return
            }
            Observable
                .of(data.list)
                .bind(to: this.tableView.rx.items(
                    cellIdentifier: this.cellId,
                    cellType: Cell.self)
                ) { (_, element, cell) in
                    if let first = element.weather.first {
                        networkService.downloadImage(with: first.icon) { (image, error) in
                            guard error == nil else {
                                print(error!)
                                return
                            }
                            let temperature = "\(Int(round(element.main.temp)).description)Cº"
                            let date = Date(timeIntervalSince1970: element.dt)
                                .formatted(with: Date.iso)
                            cell.textLabel?.text = "\(temperature) on \(date)"
                            cell.imageView?.image = image
                        }
                    }
            }
            .disposed(by: this.disposeBag)
        }
    }
}

// - MARK: ViewControllerProtocol
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
