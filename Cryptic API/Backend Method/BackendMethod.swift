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
    
    func task(completion: @escaping (DataTaskResult<Data, APIError>) -> ()) -> Task {
        let requestWithCompletionBlock = self.request
        requestWithCompletionBlock.completion = completion
        return DataTaskBuilder().build(requestWithCompletionBlock)
    }
}

extension BackendMethod {
    
    func decode<ResultType : Decodable>(into: ResultType.Type,
                                        onError: @escaping (APIError) -> ()) -> DefaultBackendMethodWithDecodedResult<ResultType> {
        var dataToDecode = Data()
        let task = task { result in
            switch result {
            case .success(let data):
                dataToDecode = data
            case .failure(let error):
                onError(error)
            }
        }
        return DefaultBackendMethodWithDecodedResult<ResultType>(initialTask: task, dataToDecode: dataToDecode)
    }
}
