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
    typealias Cell = ForecastViewCell

    var baseView: ForecastView!
    var viewModel: ForecastViewModel!

    private unowned var tableView: UITableView {
        return baseView.tableView
    }
    private let cellId = "cell"
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = baseView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Cell.self, forCellReuseIdentifier: cellId)
        bindUI()
    }
    /// if user switched from dark mode to light
    /// need to color view again
    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        tableView.adoptBackgroundMode()
    }
}
// MARK: - ViewControllerProtocol
extension ForecastViewController: ViewControllerProtocol {
    typealias View = ForecastView
    typealias ViewModel = ForecastViewModel
    typealias Controller = ForecastViewController

    static func make(
        baseView: ForecastView,
        viewModel: ForecastViewModel
    ) -> ForecastViewController {
        let forecastViewController = ForecastViewController()
        forecastViewController.tabBarItem = UITabBarItem(
            title: NSLocalizedString("forecastView", comment: "the vc name"),
            image: UIImage(named: "forecast"),
            tag: 1
        )
        forecastViewController.baseView = baseView
        forecastViewController.viewModel = viewModel
        return forecastViewController
    }

    func bindUI() {
        viewModel.output.forecast
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: Cell.self)) { (_, weather, cell) in
                cell.configure(weather: weather)
        }
        .disposed(by: disposeBag)
    }
}
