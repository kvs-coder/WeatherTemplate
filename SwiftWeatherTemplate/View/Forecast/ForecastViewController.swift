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
    typealias Forecast = [ForecastViewModel.Output]
    typealias Cell = UITableViewCell

    var baseView: ForecastView!
    var viewModel: ForecastViewModel!

    private unowned var tableView: UITableView {
        return baseView.tableView
    }
    private let cellId = "cell"

    private let disposeBag = DisposeBag()
    private let forecast = BehaviorRelay(value: Forecast())

    override func loadView() {
        view = baseView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        bindUI()
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
        viewModel.requestForecastData(
            networkService,
            location: location
        ) { [unowned self] (output) in
            self.forecast.accept(output)
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: NSNotification.Name.newLocationDetected,
            object: nil
        )
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
        forecastViewController.baseView = view
        forecastViewController.viewModel = viewModel
        return forecastViewController
    }

    func bindUI() {
        forecast
            .bind(to: tableView.rx.items(
                cellIdentifier: cellId,
                cellType: Cell.self)
            ) { (_, element, cell) in
                guard
                    let day = element.day,
                    let temp = element.temperature,
                    let data = element.imageData
                    else {
                        return
                }
                cell.textLabel?.text = "\(temp) on \(day)"
                cell.imageView?.image = UIImage(data: data)
        }
        .disposed(by: disposeBag)
    }
}
