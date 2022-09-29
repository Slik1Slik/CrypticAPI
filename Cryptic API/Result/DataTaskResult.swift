//
//  DataTaskResult.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

enum DataTaskResult<Success, Failure> where Failure : DescribedError {
    case success(Success)
    case failure(Failure)
}
