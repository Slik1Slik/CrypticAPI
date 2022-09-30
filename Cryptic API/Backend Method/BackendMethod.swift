//
//  BackendMethod.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol BackendMethod {
    var request: APIRequest { get }
    func task() -> Task
}

extension BackendMethod {
    func performCompletionBlock(on queue: DispatchQueue) -> BackendMethod {
        let oldRequest = request
        oldRequest.completionQueue = queue
        return self
    }
}

extension BackendMethod {
    func configure(with config: APIRequestConfiguration) -> BackendMethod {
        let oldRequest = request
        oldRequest.config = config
        return self
    }
}
