//
//  JSONDataFormatter.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

typealias JSONObject = [String : Any?]

final class JSONDataFormatter {
    
    private var jsonObject: JSONObject = [:]
    
    private var error: APIError?
    
    init(data: Data) {
        guard let object = try? JSONSerialization.jsonObject(with: data) as? JSONObject else {
            self.error = .incorrectDataFormat
            return
        }
        self.jsonObject = object
    }
    
    func jsonObject(onError: (APIError) -> ()) -> JSONObject {
        if let error = error {
            onError(error)
        }
        return jsonObject
    }
    
    func data() -> Data? {
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
            return nil
        }
        return data
    }
    
    func data(onError: (APIError) -> ()) -> Data {
        if let error = error {
            onError(error)
        }
        guard let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []) else {
            onError(.incorrectDataFormat)
            return .init()
        }
        return data
    }
    
    func data(_ completion: @escaping (_ data: Data?, _ error: APIError?) -> ()) {
        completion(data(), error)
    }
    
    func filter<T>(forKey key: String, andValueType: T.Type) -> Self {
        guard let newObject = jsonObject[key] as? [String : T] else {
            return self
        }
        self.jsonObject = newObject
        return self
    }
    
    func eraseStandaloneKeys() -> Self {
        var stop = false
        while !stop {
            if let key = jsonObject.keys.first,
               let nextValue = jsonObject[key] as? JSONObject
            {
                jsonObject = nextValue
            } else {
                stop = true
            }
        }
        return self
    }
}

extension Data {
    
    func formatter() -> JSONDataFormatter {
        return JSONDataFormatter(data: self)
    }
    
    func decode<T>(forType type: T.Type) -> T? where T : Decodable {
        return try? JSONManager.decode(for: T.self, from: self)
    }
}
