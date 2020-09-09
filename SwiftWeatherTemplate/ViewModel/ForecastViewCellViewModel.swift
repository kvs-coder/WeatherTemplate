//
//  ForecastViewCellViewModel.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 09.09.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

final class ForecastViewCellViewModel {
    let input = Input()
    let output = Output()
    private let disposeBag = DisposeBag()

    init(_ networkService: NetworkService) {
        input.weatherData
            .asObservable()
            .do(onNext: { [unowned self] (weatherData) in
                self.output.day.accept(weatherData?.dt.date.formatted(with: Date.iso))
                self.output.temperature.accept(weatherData?.main.temp.roundedToInt().description)
            })
            .flatMapLatest { networkService.downloadImage(url: $0?.iconUrl) }
            .startWith(UIImage.placeholder)
            .bind(to: output.image)
            .disposed(by: disposeBag)
    }
}
// MARK: - ViewModelProtocol
extension ForecastViewCellViewModel: ViewModelProtocol {
    struct Input {
        var weatherData: BehaviorRelay<WeatherData?> = BehaviorRelay(value: nil)
    }
    struct Output {
        var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
        var day: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        var temperature: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    }

    static func make(with service: NetworkService) -> ForecastViewCellViewModel {
        return ForecastViewCellViewModel(service)
    }
}
