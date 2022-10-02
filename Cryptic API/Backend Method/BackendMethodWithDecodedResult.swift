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
    
    private var initialTask: Task
    private var dataToDecode: Data
    
    func task(completion: @escaping (DataTaskResult<ResultType, APIError>) -> ()) -> Task {
        do {
            let decodedResult = try JSONManager.decode(for: ResultType.self, from: dataToDecode)
            completion(.success(decodedResult))
        } catch let error as APIError {
            completion(.failure(error))
        } catch {
            completion(.failure(.unknownError))
        }
        return initialTask
    }
    
    init(initialTask: Task, dataToDecode: Data) {
        self.initialTask = initialTask
        self.dataToDecode = dataToDecode
    }
}
