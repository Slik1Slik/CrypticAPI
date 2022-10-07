//
//  HomeMVVMModuleBuilder.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import UIKit

final class HomeMVVMModuleBuilder : MVVMModuleBuilder {
    
    func build() -> UIViewController {
        let viewModel = HomeViewModel()
        let vc = HomeViewController()
        vc.set(viewModel)
        vc.listen()
        return vc
    }
}
