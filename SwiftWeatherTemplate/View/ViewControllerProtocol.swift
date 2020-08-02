//
//  ViewControllerProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    associatedtype View where View: ViewProtocol
    associatedtype ViewModel where ViewModel: ViewModelProtocol
    associatedtype Controller where Controller: UIViewController

    var baseView: View! { get }
    var viewModel: ViewModel! { get }

    ///Factory method
    static func make(view: View, viewModel: ViewModel) -> Controller

    func bindUI()
}
