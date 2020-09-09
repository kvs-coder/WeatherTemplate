//
//  ForecastViewCell.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 09.09.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ForecastViewCell: UITableViewCell {
    private let viewModel = ForecastViewCellViewModel(NetworkService())
    private let disposeBag = DisposeBag()
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "articleTitle",
            comment: "article title"
        )
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString(
            "articleSubtitle",
            comment: "article subtitle"
        )
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    let labelStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = 5
        return stackView
    }()
    let weatherImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage.placeholder
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(weatherImageView)
        addSubview(labelStackView)
        labelStackView.addArrangedSubview(dayLabel)
        labelStackView.addArrangedSubview(temperatureLabel)
        makeConstraints()
        viewModel.output.day
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: dayLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.temperature
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.output.image
            .asObservable()
            .observeOn(MainScheduler.instance)
            .bind(to: weatherImageView.rx.image)
            .disposed(by: disposeBag)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configure(weather: WeatherData) {
        viewModel.input.weatherData.accept(weather)
    }
}
// MARK: - ViewProtocol
extension ForecastViewCell: ViewProtocol {
    func makeConstraints() {
        weatherImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(layoutMarginsGuide)
            make.width.equalTo(50)
        }
        labelStackView.snp.makeConstraints { (make) in
            make.left.equalTo(weatherImageView.snp.right).offset(10)
            make.top.right.bottom.equalTo(layoutMarginsGuide)
        }
    }
}
