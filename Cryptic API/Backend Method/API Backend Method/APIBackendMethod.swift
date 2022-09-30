//
//  APIBackendMethod.swift
//  Cryptic API
//
//  Created by Slik on 30.09.2022.
//

import Foundation

protocol APIBackendMethod {
    
    var path: String { get }
    var parameters: [String : String] { get }

    func task(completion: @escaping (DataTaskResult<Data, APIError>) -> ()) -> Task
}
