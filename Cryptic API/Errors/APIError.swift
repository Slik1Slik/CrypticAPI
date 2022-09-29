//
//  APIError.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

enum APIError : DescribedError {
    
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case tooManyRequests
    case internalServerError
    case failedToCreateURL
    case notHTTPResponse
    case unknownServersideError(Error)
    case unknownError
    case decodingFailed
    case encodingFailed
    case incorrectDataFormat
    case noConnection
    
    var description: String {
        switch self {
        case .badRequest:
            return "Bad request."
        case .unauthorized:
            return "You are not authorized. Please, log in."
        case .forbidden:
            return "Forbidden resource."
        case .notFound:
            return "Resource not found."
        case .tooManyRequests:
            return "You've made too many requests to the server. Please, try again later or contact us."
        case .internalServerError:
            return "InternalServerError."
        case .failedToCreateURL:
            return "Failed to make a request. Please, double-check input."
        case .notHTTPResponse:
            return "Unknown response type. Please, try again later."
        case .unknownServersideError(let error):
            return error.localizedDescription
        case .unknownError:
            return "Unknown error. Please, try again later."
        case .decodingFailed:
            return "Failed to decode data. Please, try again later."
        case .encodingFailed:
            return "Failed to decode data. Please, try again later."
        case .incorrectDataFormat:
            return "Incorrect data format."
        case .noConnection:
            return "No internet connection. Please, restore the connection."
        }
    }
    
    static func errorFor(code: Int) -> Self? {
        switch code {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .unauthorized
        case 404: return .notFound
        case 429: return .tooManyRequests
        case 500: return .internalServerError
        default:
            return nil
        }
    }
}
