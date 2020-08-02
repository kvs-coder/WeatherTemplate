//
//  AppDelegate.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var locationManager = CLLocationManager()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
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
