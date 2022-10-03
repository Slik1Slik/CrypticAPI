//
//  HomeViewModelError.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

enum HomeViewModelError : DescribedError {
    
    case someDataLost(APIError)
    case noInternetConnection
    
    var description: String {
        switch self {
        case .someDataLost(let apiError):
            return apiError.description
        case .noInternetConnection:
            return "No Internet connection."
        }
    }
}
