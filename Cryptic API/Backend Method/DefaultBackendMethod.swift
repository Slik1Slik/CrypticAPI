//
//  DefaultBackendMethod.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

final class DefaultBackendMethod : BackendMethod {
    
    private(set) var request: APIRequest = .init()
    
    func task() -> Task {
        DataTaskBuilder().build(request)
    }
}

extension DefaultBackendMethod {
    func performCompletionBlock(on queue: DispatchQueue) -> BackendMethod {
        request.completionQueue = queue
        return self
    }
}

extension DefaultBackendMethod {
    func configureRequest(with config: APIRequestConfiguration) -> BackendMethod {
        request.config = config
        return self
    }
}
