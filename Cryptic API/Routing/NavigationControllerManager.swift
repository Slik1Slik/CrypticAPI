//
//  NavigationControllerManager.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import UIKit

final class NavigationControllerManager {
    
    static let shared: NavigationControllerManager = {
        return NavigationControllerManager()
    }()
    
    private init() { }
    
    private(set) var navigationController: UINavigationController?
    
    func setNVC(_ nvc: UINavigationController) {
        self.navigationController = nvc
    }
    
    func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
}
