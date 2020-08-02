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
import Network
import SwiftyJSON

class ForecastViewController: UIViewController {
    typealias Cell = UITableViewCell

    var forecastView: ForecastView!
    var viewModel: ForecastViewModel!

    private unowned var tableView: UITableView {
        return forecastView.tableView
    }
    private let cellId = "cell"
    private let disposeBag = DisposeBag()
    let monitor = NWPathMonitor()

    override func loadView() {
        view = forecastView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(locationUpdated),
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
        let networkService = NetworkService()
        requestForecastData(
            networkService,
            location: location,
            completionHandler: { [weak self] (forecastData, error) in
                guard let this = self else {
                    return
                }
                guard
                    let data = forecastData,
                    error == nil
                    else {
                        logError(error!.localizedDescription)
                        return
                }
                this.bindUI(with: data, networkService)
        })
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.newLocationDetected,
            object: nil
        )
    }

    private func requestForecastData(
        _ networkService: NetworkService,
        location: Location,
        completionHandler: @escaping (ForecastData?, Error?) -> Void
    ) {
        networkService.requestForecast(
            latitude: location.latitude,
            longitude: location.longitude,
            completionHandler: completionHandler
        )
    }
    private func bindUI(
        with data: ForecastData,
        _ networkService: NetworkService
    ) {
        Observable
            .of(data.list)
            .bind(to: tableView.rx.items(
                cellIdentifier: cellId,
                cellType: Cell.self)
            ) { (_, element, cell) in
                if let first = element.weather.first {
                    networkService.downloadImage(with: first.icon) { (image, error) in
                        guard error == nil else {
                            logError(error!.localizedDescription)
                            return
                        }
                        let temperature = "\(element.main.temp.roundedToInt().description)Cº"
                        let date = Date(timeIntervalSince1970: element.dt)
                            .formatted(with: Date.iso)
                        cell.textLabel?.text = "\(temperature) on \(date)"
                        cell.imageView?.image = image
                    }
                }
        }
        .disposed(by: disposeBag)
    }
}

// - MARK: ViewControllerProtocol
extension ForecastViewController: ViewControllerProtocol {
    typealias View = ForecastView
    typealias ViewModel = ForecastViewModel
    typealias Controller = ForecastViewController

    static func make(
        view: ForecastView,
        viewModel: ForecastViewModel
    ) -> ForecastViewController {
        let forecastViewController = ForecastViewController()
        forecastViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("forecastView", comment: "the vc name"),
            image: UIImage(named: "forecast"),
            tag: 1
        )
        forecastViewController.forecastView = view
        forecastViewController.viewModel = viewModel
        return forecastViewController
    }
}
