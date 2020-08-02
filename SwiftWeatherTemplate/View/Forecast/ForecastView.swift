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
        backgroundColor = .white
        addSubview(tableView)
        makeConstraints()
    }
}

extension ForecastView: ViewProtocol {
    func makeConstraints() {
        tableView.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
        }
    }
}
