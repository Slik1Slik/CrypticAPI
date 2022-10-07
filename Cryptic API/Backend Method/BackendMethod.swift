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

extension BackendMethod {
    func configure(_ updatingBlock: (APIRequest) -> ()) -> BackendMethod {
        updatingBlock(request)
        return self
    }
}

extension BackendMethod {
    
    func task(completion: @escaping (DataTaskResult<Data, APIError>) -> ()) -> Task {
        let requestWithCompletionBlock = self.request
        requestWithCompletionBlock.completion = completion
        return DataTask(request: requestWithCompletionBlock)
    }
}

extension BackendMethod {
    
    func decode<T>(into: T.Type) -> DefaultBackendMethodWithDecodedResult<T> {
        return DefaultBackendMethodWithDecodedResult(from: self)
    }
}
