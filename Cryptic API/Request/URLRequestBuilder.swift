//
//  URLRequestBuilder.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol URLRequestBuilder {
    func build(from config: APIRequestConfiguration) throws -> URLRequest
}

final class APIURLRequestBuilder : URLRequestBuilder {
    
    private let baseScheme: String = "https"
    private let baseHost: String = "data.messari.io"
    private let baseGroup: String = "api"
    private let apiKey: String = "5894cbd4-4655-45ec-ad6a-157f813f3ac6"
    
    func build(from config: APIRequestConfiguration) throws -> URLRequest
    {
        var components = URLComponents()
        
        components.scheme = baseScheme
        setHTTPMethod(config.httpMethod, to: &components)
        components.host = baseHost
        components.path = "/\(baseGroup)/\(config.apiVersion)/\(config.path)"
        components.queryItems = config.parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let url = components.url else {
            throw APIError.failedToCreateURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = config.httpMethod.rawValue
        request.setValue(apiKey, forHTTPHeaderField: "x-messari-api-key")
        
        return request
    }
    
    private func setHTTPMethod(_ method: HTTPMethod, to components: inout URLComponents) {
        
        switch method {
        case .connect(let port):
            components.port = port
        default: break
        }
    }
}
