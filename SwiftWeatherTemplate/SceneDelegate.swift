//
//  SceneDelegate.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: scene)
        let tabBarViewController = UITabBarController()
        tabBarViewController.addChild(WeatherViewController.make())
        tabBarViewController.addChild(ForecastViewController.make())
        window?.rootViewController = UINavigationController(
            rootViewController: tabBarViewController
        )
        window?.makeKeyAndVisible()
    }
}
