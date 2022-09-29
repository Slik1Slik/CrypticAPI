//
//  TaskBuilder.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol TaskBuilder {
    func build(_ request: APIRequest) -> Task
}

final class DataTaskBuilder : TaskBuilder {
    
    private var requestBuilder: URLRequestBuilder = APIURLRequestBuilder()
    
    func build(_ request: APIRequest) -> Task {
        
        guard let urlRequest = try? requestBuilder.build(from: request.config) else
        {
            request.completion(.failure(.failedToCreateURL))
            return DataTask(dataTask: nil)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            request.completionQueue.async {
                DataTaskResultHandler.handle(data: data,
                                             response: response,
                                             error: error,
                                             completion: request.completion)
            }
        }
        return DataTask(dataTask: task)
    }
}
