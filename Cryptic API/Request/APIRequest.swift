//
//  APIRequest.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

final class APIRequest {
    
    var config: APIRequestConfiguration = .init()
    
    var completion: (DataTaskResult<Data, APIError>) -> () = { _ in }
    var completionQueue: DispatchQueue = .main
    
    init(config: APIRequestConfiguration = .init(),
         completion: @escaping (DataTaskResult<Data, APIError>) -> () = { _ in },
         completionQueue: DispatchQueue = .main) {
        
        self.config = config
        
        self.completion = completion
        self.completionQueue = completionQueue
    }
}

struct APIRequestConfiguration {
    
    var path: String = ""
    var parameters: [String : String] = [:]
    var httpMethod: HTTPMethod = .get
    var apiVersion: String = "v1"
    var headers: [String : String] = [:]
    
    init(path: String = "",
         parameters: [String : String] = [:],
         httpMethod: HTTPMethod = .get,
         apiVersion: String = "v1",
         headers: [String : String] = [:]) {
        
        self.path = path
        self.parameters = parameters
        self.httpMethod = httpMethod
        self.apiVersion = apiVersion
        self.headers = headers
    }
}
