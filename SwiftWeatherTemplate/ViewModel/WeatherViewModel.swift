//
//  WeatherViewModel.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import RxSwift

class WeatherViewModel: ViewModelProtocol {
    struct Input {
        let location: Location
    }
    struct Output {
        var day: String?
        var city: String?
        var temperature: String?
        var imageData: Data?
    }

    private let disposeBag = DisposeBag()

    func requestWeatherData(
        location: Location,
        completionHandler: @escaping (Output) -> Void
    ) {
        let input = Input(location: location)
        let networkService = NetworkService()
        networkService.requestWeather(
            latitude: input.location.latitude,
            longitude: input.location.longitude
        )
            .subscribe(
                onNext: { (weatherData) in
                    let date = Date(timeIntervalSince1970: weatherData.dt)
                        .formatted(with: Date.iso)
                    let temp = "\(weatherData.main.temp.roundedToInt().description)Cº"
                    if let icon = weatherData.weather.first?.icon {
                        networkService.downloadImage(with: icon) { (cache, error) in
                            guard error == nil else {
                                logError(error!.localizedDescription)
                                return
                            }
                            let output = Output(
                                day: date,
                                city:
                                weatherData.name,
                                temperature: temp,
                                imageData: cache
                            )
                            completionHandler(output)
                        }
                    }
                }, onError: { (error) in
                    logError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
