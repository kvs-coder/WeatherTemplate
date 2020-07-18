//
//  SceneDelegate.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit
import Network

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let monitor = NWPathMonitor()

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
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
    }

    private func makeRootViewController() -> UINavigationController {
        let tabBarViewController = UITabBarController()
        tabBarViewController.addChild(WeatherViewController.make())
        tabBarViewController.addChild(ForecastViewController.make())
        return UINavigationController(rootViewController: tabBarViewController)
    }
}
