//
//  NetworkService.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage
import SwiftyJSON
import RxSwift
import UIKit

class NetworkService {
    func requestForecast(
        latitude: Double,
        longitude: Double
    ) -> Observable<[WeatherData]> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.makeRequest(
                enpoint: "forecast",
                latitude: latitude,
                longitude: longitude
            ).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let list = ForecastData.parse(from: JSON(value))?.list ?? []
                    observer.onNext(list)
                case .failure(let error):
                    logError(error)
                    observer.onNext([])
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    func requestWeather(
        latitude: Double,
        longitude: Double
    ) -> Observable<WeatherData?> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.makeRequest(
                enpoint: "weather",
                latitude: latitude,
                longitude: longitude
            ).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    let weatherData = WeatherData.parse(from: JSON(value))
                    observer.onNext(weatherData)
                case .failure(let error):
                    logError(error)
                    observer.onNext(nil)
                }
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    func downloadImage(url: URL?) -> Observable<UIImage?> {
        return Observable.create { (observer) -> Disposable in
            // Image will be always cached after download
            let imageDownloader = ImageDownloader(
                configuration: ImageDownloader.defaultURLSessionConfiguration(),
                downloadPrioritization: .fifo,
                imageCache: AutoPurgingImageCache()
            )
            if let url = url {
                let request = URLRequest(url: url)
                imageDownloader.download(request) { response in
                    switch response.result {
                    case .success(let image):
                        observer.onNext(image)
                    case .failure(let error):
                        logError(error)
                        observer.onNext(UIImage.placeholder)
                    }
                    observer.onCompleted()
                }
            } else {
                observer.onNext(UIImage.placeholder)
            }
            return Disposables.create()
        }
    }

    @discardableResult
    private func makeRequest(
        enpoint: String,
        latitude: Double,
        longitude: Double
    ) -> DataRequest {
        let parameters: [String : Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric",
            "appid": Environment.apiKey
        ]
        return AF.request(
            "https://api.openweathermap.org/data/2.5/\(enpoint)",
            parameters: parameters,
            encoding: URLEncoding.queryString
        )
    }
}
