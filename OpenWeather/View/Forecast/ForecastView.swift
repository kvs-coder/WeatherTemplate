//
//  ForecastView.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 18.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import SnapKit

final class ForecastView: UIView {
    let tableView = UITableView()

    convenience init() {
        self.init(frame: .zero)
        tableView.adoptBackgroundMode()
        addSubview(tableView)
        makeConstraints()
    }
}
// MARK: - ViewProtocol
extension ForecastView: ViewProtocol {
    func makeConstraints() {
        tableView.snp.makeConstraints {
            $0.left.top.right.bottom.equalToSuperview()
        }
    }
}
