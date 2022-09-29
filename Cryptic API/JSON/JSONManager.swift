//
//  JSONManager.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

final class JSONManager {
    
    static func decode<T>(for type: T.Type,
                          from data: Data,
                          decoder: JSONDecoder = Decoder.default.decoder,
                          completion: @escaping (DataTaskResult<T, APIError>) -> ()) where T: Decodable
    {
        guard let result = try? decoder.decode(T.self, from: data) else {
            completion(.failure(.decodingFailed))
            return
        }
        completion(.success(result))
    }
    
    static func encode<T>(_ object: T,
                          encoder: JSONEncoder = Encoder.default.encoder,
                          completion: (DataTaskResult<Data, APIError>) -> ()) where T: Encodable
    {
        guard let data = try? encoder.encode(object) else {
            completion(.failure(.encodingFailed))
            return
        }
        completion(.success(data))
    }
    
    static func decode<T>(for type: T.Type,
                          from data: Data,
                          decoder: JSONDecoder = Decoder.default.decoder) throws -> T where T: Decodable
    {
        guard let result = try? decoder.decode(T.self, from: data) else {
            throw APIError.decodingFailed
        }
        return result
    }
    
    static func encode<T>(_ object: T,
                          encoder: JSONEncoder = Encoder.default.encoder) throws -> Data where T: Encodable
    {
        guard let result = try? encoder.encode(object) else {
            throw APIError.decodingFailed
        }
        return result
    }
    
    enum Decoder {
        case `default`
        case custom(JSONDecoder)
        
        var decoder: JSONDecoder {
            switch self {
            case .default:
                let decoder = JSONDecoder()
                decoder.allowsJSON5 = true
                decoder.dataDecodingStrategy = .deferredToData
                decoder.dateDecodingStrategy = .formatted(DateConstants.dateFormatter)
                return decoder
            case .custom(let customDecoder):
                return customDecoder
            }
        }
    }
    
    enum Encoder {
        case `default`
        case custom(JSONEncoder)
        
        var encoder: JSONEncoder {
            switch self {
            case .default:
                let encoder = JSONEncoder()
                encoder.dataEncodingStrategy = .base64
                encoder.outputFormatting = [.prettyPrinted]
                encoder.dateEncodingStrategy = .formatted(DateConstants.dateFormatter)
                return encoder
            case .custom(let customEncoder):
                return customEncoder
            }
        }
    }
}
