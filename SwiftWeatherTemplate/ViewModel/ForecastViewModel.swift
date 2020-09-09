//
//  ForecastViewModel.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

final class ForecastViewModel {
    let input = Input()
    let output = Output()
    private let disposeBag = DisposeBag()

    private init(_ networkService: NetworkService) {
        input.location
            .asObservable()
            .throttle(RxTimeInterval.seconds(2), scheduler: MainScheduler.instance)
            .flatMapLatest {
                networkService.requestForecast(
                    latitude: $0.latitude,
                    longitude: $0.longitude
                )
        }
        .bind(to: output.forecast)
        .disposed(by: disposeBag)
    }
}
// MARK: - ViewModelProtocol
extension ForecastViewModel: ViewModelProtocol {
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
        var forecast = BehaviorRelay(value: [WeatherData]())
    }

    static func make(with service: NetworkService) -> ForecastViewModel {
         return ForecastViewModel(service)
    }
}
