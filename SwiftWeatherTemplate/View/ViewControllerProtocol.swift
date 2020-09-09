//
//  ViewControllerProtocol.swift
//  SwiftWeatherTemplate
//
//  Created by Florian on 17.07.20.
//  Copyright © 2020 Florian. All rights reserved.
//

import UIKit

protocol ViewControllerProtocol {
    /// To conform the protocol, associated Types
    /// should exist, Xcode will show compilation error
    /// if some of Types were not created
    associatedtype View where View: ViewProtocol
    associatedtype ViewModel where ViewModel: ViewModelProtocol
    associatedtype Controller where Controller: UIViewController

    /// VC's initial view
    var baseView: View! { get }
    /// VC's initial viewModel
    var viewModel: ViewModel! { get }

    /// Factory method to build VC with view and model
    static func make(baseView: View, viewModel: ViewModel) -> Controller

    /// For reactive bahavior, make all binds inside this func and call it in
    /// VC's viewDidLoad() method
    func bindUI()
}
