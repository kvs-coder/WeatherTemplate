//
//  WeatherView.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import SnapKit

final class WeatherView: UIView {
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let generalInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    let cityLabel = UILabel()
    let dayLabel = UILabel()
    let weatherInfoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.spacing = 5.0
        stackView.distribution = .fillProportionally
        return stackView
    }()
    let temperatureLabel = UILabel()
    let weatherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    convenience init() {
        self.init(frame: .zero)
        // Set up the support of dark/light mode
        adoptMode()
        addSubview(generalInfoStackView)
        generalInfoStackView.addArrangedSubview(cityLabel)
        generalInfoStackView.addArrangedSubview(dayLabel)
        addSubview(weatherInfoStackView)
        weatherInfoStackView.addArrangedSubview(temperatureLabel)
        weatherInfoStackView.addArrangedSubview(weatherImageView)
        makeConstraints()
    }
}

extension WeatherView: ViewProtocol {
    func makeConstraints() {
        generalInfoStackView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalTo(layoutMarginsGuide).inset(5)
            maker.height.equalToSuperview().dividedBy(3.0)
        }
        weatherInfoStackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(generalInfoStackView.snp.bottom)
            maker.left.right.bottom.equalTo(layoutMarginsGuide).inset(5)
        }
    }
}
