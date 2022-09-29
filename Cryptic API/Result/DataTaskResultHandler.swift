//
//  DataTaskResultHandler.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

final class DataTaskResultHandler {
    
    static func handle(data: Data?,
                       response: URLResponse?,
                       error: Error?,
                       completion: @escaping (DataTaskResult<Data, APIError>) -> ())
    {
        if let data = data {
            completion(.success(data))
            return
        }
        if let response = response,
           let httpResponse = (response as? HTTPURLResponse) {
            
            if let apiError = APIError.errorFor(code: httpResponse.statusCode) {
                completion(.failure(apiError))
                return
            }
        }
        if let error = error
        {
            completion(.failure(APIError.unknownServersideError(error)))
            return
        }
        completion(.failure(APIError.unknownError))
    }
}
