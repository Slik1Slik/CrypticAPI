//
//  BackendAPIMethod.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol BackendAPIMethod {
    var request: APIRequest { get }
    func task() -> Task
}

extension BackendAPIMethod {
    func performCompletionBlock(on queue: DispatchQueue) -> BackendAPIMethod {
        let oldRequest = request
        oldRequest.completionQueue = queue
        return self
    }
}

extension BackendAPIMethod {
    func configure(with config: APIRequestConfiguration) -> BackendAPIMethod {
        let oldRequest = request
        oldRequest.config = config
        return self
    }
}
