//
//  DataTaskResultBuilder.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol DataTaskResultDataFormatter {
    func format(from data: Data) -> DataTaskResult<Data, APIError>
}

final class DefaultDataTaskResultDataFormatter : DataTaskResultDataFormatter {
    
    func format(from data: Data) -> DataTaskResult<Data, APIError> {
        
        var formatterError: APIError?
        
        let jsonObject = data
            .formatter()
            .jsonObject { error in
                formatterError = error
            }
        
        if let error = formatterError {
            return .failure(error)
        }
        
        if let jsonData = jsonObject["data"] as? JSONObject,
           let data = jsonData.data(),
           let formattedData = data.formatter().eraseStandaloneKeys().data()
        {
            return .success(formattedData)
        }
        
        if let errorCode = jsonObject["error_code"] as? Int
        {
            return .failure(.errorFor(code: errorCode) ?? .unknownError)
        }
        
        return .failure(.unknownError)
    }
}

extension Dictionary where Key == JSONObject.Key, Value == JSONObject.Value {
    
    func data() -> Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
