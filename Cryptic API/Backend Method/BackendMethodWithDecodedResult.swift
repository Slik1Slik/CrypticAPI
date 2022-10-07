//
//  BackendMethodWithDecodedResult.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

protocol BackendMethodWithDecodedResult {
    
    associatedtype ResultType : Decodable
    
    func task(completion: @escaping (DataTaskResult<ResultType, APIError>) -> ()) -> Task
}

final class DefaultBackendMethodWithDecodedResult<T : Decodable> : BackendMethodWithDecodedResult {
    
    typealias ResultType = T
    
    private var callingMethod: BackendMethod
    
    func task(completion: @escaping (DataTaskResult<ResultType, APIError>) -> ()) -> Task {
        let task = callingMethod.task { dataTaskResult in
            switch dataTaskResult {
            case .success(let data):
                guard let decodedData = try? JSONManager.decode(for: ResultType.self,
                                                                from: data) else {
                    completion(.failure(.decodingFailed))
                    return
                }
                completion(.success(decodedData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        return task
    }
    
    init(from method: BackendMethod) {
        self.callingMethod = method
    }
}
