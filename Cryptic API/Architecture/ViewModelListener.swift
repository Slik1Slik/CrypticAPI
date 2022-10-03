//
//  ViewModelListener.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import Foundation

protocol ViewModelListener : AnyObject {
    
    associatedtype ViewModel
    
    func set(_ viewModel: ViewModel)
    
    func listen()
}
