//
//  ForecastViewModel.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 02.08.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import RxSwift

class ForecastViewModel: ViewModelProtocol {
    struct Input {
        let location: Location
    }
    struct Output {
        var day: String?
        var temperature: String?
        var imageData: Data?
    }

    private let disposeBag = DisposeBag()

    func requestForecastData(
        _ networkService: NetworkService,
        location: Location,
        completionHandler: @escaping ([Output]) -> Void
    ) {
        let input = Input(location: location)
        networkService.requestForecast(
            latitude: input.location.latitude,
            longitude: input.location.longitude
        )
            .subscribe(
                onNext: { (forecastData) in
                    let group = DispatchGroup()
                    var outputs = [Output]()
                    forecastData.list.forEach { (element) in
                        if let first = element.weather.first {
                            group.enter()
                            networkService.downloadImage(with: first.icon) { (imageData, error) in
                                guard error == nil else {
                                    logError(error!.localizedDescription)
                                    return
                                }
                                let temperature = "\(element.main.temp.roundedToInt().description)Cº"
                                let date = Date(timeIntervalSince1970: element.dt)
                                    .formatted(with: Date.iso)
                                let output = Output(
                                    day: date,
                                    temperature: temperature,
                                    imageData: imageData
                                )
                                outputs.append(output)
                                group.leave()
                            }
                        }
                    }
                    group.notify(queue: .main) {
                        completionHandler(outputs)
                    }
            }, onError: { (error) in
                logError(error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
}
