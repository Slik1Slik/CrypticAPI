//
//  HomeViewModelInput.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

protocol HomeViewModelInput {
    
    func update()
    func search(text: String)
    func select(atIndex index: Int)
}
