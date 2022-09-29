//
//  DescribedError.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol DescribedError : Error {
    var description: String { get }
}

extension DescribedError {
    var title: String {
        return "Error"
    }
}
