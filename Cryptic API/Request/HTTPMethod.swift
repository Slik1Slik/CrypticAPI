//
//  HTTPMethod.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

enum HTTPMethod {
    
    typealias HTTPPort = Int?
    
    case `get`
    case post
    case connect(HTTPPort)
    case delete
    case head
    case options
    case patch
    case put
    case trace
    
    var rawValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .connect(_):
            return "CONNECT"
        case .delete:
            return "DELETE"
        case .head:
            return "HEAD"
        case .options:
            return "OPTIONS"
        case .patch:
            return "PATCH"
        case .put:
            return "PUT"
        case .trace:
            return "TRACE"
        }
    }
}
