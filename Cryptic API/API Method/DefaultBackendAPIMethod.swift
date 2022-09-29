//
//  DefaultBackendAPIMethod.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

final class DefaultBackendAPIMethod : BackendAPIMethod {
    
    private(set) var request: APIRequest = .init()
    
    func task() -> Task {
        DataTaskBuilder().build(request)
    }
}

extension DefaultBackendAPIMethod {
    func performCompletionBlock(on queue: DispatchQueue) -> Self {
        request.completionQueue = queue
        return self
    }
}

extension DefaultBackendAPIMethod {
    func configureRequest(with config: APIRequestConfiguration) -> BackendAPIMethod {
        request.config = config
        return self
    }
}
