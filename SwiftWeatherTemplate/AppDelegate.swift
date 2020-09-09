//
//  AppDelegate.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import CoreLocation
import Network

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    lazy var locationManager = CLLocationManager()
    private let monitor = NWPathMonitor()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = makeRootViewController()
        window?.makeKeyAndVisible()
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                guard
                    let viewController = self?.window?.rootViewController
                    else {
                    return
                }
                if path.status == .satisfied {
                    logDebug("path's good")
                } else {
                    let alert = viewController.makeNoConnectionAlert()
                    viewController.present(
                        alert,
                        animated: true,
                        completion: nil
                    )
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        return true
    }

    private func makeRootViewController() -> UINavigationController {
        let networkService = NetworkService()
        let tabBarViewController = UITabBarController()
        tabBarViewController.addChild(WeatherViewController.make(
            baseView: WeatherView(),
            viewModel: WeatherViewModel.make(with: networkService)
            )
        )
        tabBarViewController.addChild(ForecastViewController.make(
            baseView: ForecastView(),
            viewModel: ForecastViewModel.make(with: networkService)
            )
        )
        return UINavigationController(rootViewController: tabBarViewController)
    }
}
// MARK: - CLLocationManagerDelegate
extension AppDelegate: CLLocationManagerDelegate {
    func locationManager(
        _ manager: CLLocationManager,
        didChangeAuthorization status: CLAuthorizationStatus
    ) {
        switch status {
        case .notDetermined, .restricted, .denied:
            logInfo(".notDetermined, .restricted, .denied")
        case .authorizedAlways, .authorizedWhenInUse:
            logInfo(".authorizedAlways, .authorizedWhenInUse")
            locationManager.startUpdatingLocation()
        @unknown default:
            return
        }
    }
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        for location in locations {
            NotificationCenter.default.post(
                name: NSNotification.Name.newLocationDetected,
                object: nil,
                userInfo: Location(
                    latitude: location.coordinate.latitude,
                    longitude: location.coordinate.longitude
                ).toDictionary()
            )
        }
    }
}
