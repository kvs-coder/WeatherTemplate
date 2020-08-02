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

class NetworkService {
    func requestForecast(
        latitude: Double,
        longitude: Double
    ) -> Observable<ForecastData> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.makeRequest(
                enpoint: "forecast",
                parameters: self.setParameters(
                    latitude: latitude,
                    longitude: longitude
            )).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let weatherData = ForecastData.parse(from: JSON(value)) {
                        observer.onNext(weatherData)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func requestWeather(
        latitude: Double,
        longitude: Double
    ) -> Observable<WeatherData> {
        return Observable.create { [unowned self] (observer) -> Disposable in
            self.makeRequest(
                enpoint: "weather",
                parameters: self.setParameters(
                    latitude: latitude,
                    longitude: longitude
            )).responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    if let weatherData = WeatherData.parse(from: JSON(value)) {
                        observer.onNext(weatherData)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    func downloadImage(with id: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            imageCache: AutoPurgingImageCache()
        )
        guard
            let url = URL(string:"http://openweathermap.org/img/wn/\(id)@2x.png")
            else {
                return
        }
        let request = URLRequest(url: url)
        imageDownloader.download(request) { response in
            switch response.result {
            case .success(let image):
                completionHandler(image.pngData(), nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }

    @discardableResult
    private func makeRequest(
        enpoint: String,
        parameters: [String: Any]
    ) -> DataRequest {
        return AF.request(
            "https://api.openweathermap.org/data/2.5/\(enpoint)",
            parameters: parameters,
            encoding: URLEncoding.queryString
        )
    }
    private func setParameters(
        latitude: Double,
        longitude: Double
    ) -> [String: Any] {
             return [
                 "lat": latitude,
                 "lon": longitude,
                 "units": "metric",
                 "appid": Environment.apiKey
             ]
    }
}
