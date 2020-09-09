//
//  WeatherViewModel.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Alamofire

final class WeatherViewModel {
    let input = Input()
    let output = Output()
    private let disposeBag = DisposeBag()

    private init(_ networkService: NetworkService) {
        input.location
            .asObservable()
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest {
                networkService.requestWeather(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
        }
        .do(onNext: { [unowned self] (weatherData) in
            self.output.city.accept(weatherData?.name)
            self.output.day.accept(weatherData?.dt.date.formatted(with: Date.iso))
            self.output.temperature.accept(weatherData?.main.temp.roundedToInt().description)
        })
            .flatMapLatest({ networkService.downloadImage(url: $0?.iconUrl) })
            .startWith(UIImage.placeholder)
            .bind(to: output.image)
            .disposed(by: disposeBag)
    }
}
// MARK: - ViewModelProtocol
extension WeatherViewModel: ViewModelProtocol {
    struct Input {
        var location: BehaviorRelay<Location> = BehaviorRelay(
            value: Location(
                latitude: 51.0,
                longitude: 51.0
            )
        )
    }
    struct Output {
        var loadInProgress = BehaviorRelay(value: false)
        var city: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        var day: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        var temperature: BehaviorRelay<String?> = BehaviorRelay(value: nil)
        var image: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    }

    static func make(with service: NetworkService) -> WeatherViewModel {
        return WeatherViewModel(service)
    }
}
