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

enum API {
    static let key = "5dfac62572f7baa9d93575ba3662c22b"
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let imageUrl = "http://openweathermap.org/img/wn/"
}

class NetworkService {
    func requestWeather(
        latitude: Double,
        longitude: Double,
        completionHandler: @escaping (WeatherData?, Error?) -> Void
    ) {
        let parameters: [String: Any] = [
            "lat": latitude,
            "lon": longitude,
            "units": "metric",
            "appid": API.key
        ]
        AF.request(
            "\(API.baseUrl)weather",
            parameters: parameters,
            encoding: URLEncoding.queryString
        ).responseJSON { (response) in
            switch response.result {
            case .success(let value):
                let weatherData = WeatherData.parse(
                    from: JSON(value)
                )
                completionHandler(weatherData, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }

    func downloadImage(
            with id: String,
            completionHandler: @escaping (Image?, Error?
        ) -> Void) {
        let imageDownloader = ImageDownloader(
            configuration: ImageDownloader.defaultURLSessionConfiguration(),
            downloadPrioritization: .fifo,
            maximumActiveDownloads: 4,
            imageCache: AutoPurgingImageCache()
        )
        guard let url = URL(string:"\(API.imageUrl)\(id)@2x.png") else {
            return
        }
        let request = URLRequest(url: url)
        imageDownloader.download(request) { response in
            switch response.result {
            case .success(let image):
                completionHandler(image, nil)
            case .failure(let error):
                completionHandler(nil, error)
            }
        }
    }
}

//5 days api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={your api key}
//now api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={your api key}
