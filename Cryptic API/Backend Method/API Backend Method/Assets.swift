//
//  Assets.swift
//  Cryptic API
//
//  Created by Slik on 30.09.2022.
//

import Foundation

extension CrypticAPI {
    
    enum Assets : APIBackendMethod, ReflectableEnum, BackendMethod {
        
        var request: APIRequest {
            let config = APIRequestConfiguration(path: path,
                                                 parameters: parameters,
                                                 httpMethod: .get,
                                                 apiVersion: "v2")
            return APIRequest(config: config)
        }
        
        typealias AssetKey = String

        case all
        case profile(AssetKey)
        case marketData(AssetKey)
        case timeseries(AssetKey, TimeseriesOption)

        var path: String {
            var path: String = typeName()
            switch self {
                case .all: break
                case .profile(let key): path += "/\(key)/\(caseName())"
                case .marketData(let key): path += "/\(key)/metrics/market-data"
                case .timeseries(let key, _): path += "/\(key)/metrics/price/time-series"
            }
            return path
        }

        var parameters: [String : String] {
            var params: [String : String] = [:]
            switch self {
                case .all: break
                case .profile:
                    params["fields"] = "symbol,name,overview,background"
                case .marketData(_): break
                case .timeseries(_, let option):
                    params["fields"] = "symbol,values"
                    params["start"] = option.dateInterval.start.string(format: "yyyy-MM-dd")
                    params["end"] = option.dateInterval.end.string(format: "yyyy-MM-dd")
                    params["interval"] = "1d"
                    params["columns"] = "close"
                    params["timestamp-format"] = "unix-seconds"
            }
            return params
        }
        
        func task() -> Task {
            return DataTask(request: request)
        }
    }
}

extension CrypticAPI.Assets {

    enum TimeseriesOption {
        
        case day
        case week
        case year
        case custom(DateInterval)

        var dateInterval: DateInterval {
            let endDate = Date()
            var startDate: Date?
            let calendar = Calendar(identifier: .gregorian)
            switch self {
            case .day:
                startDate = calendar.date(byAdding: .day,
                                          value: -1,
                                          to: endDate)
            case .week:
                startDate = calendar.date(byAdding: .day,
                                          value: -7,
                                          to: endDate)
            case .year:
                startDate = calendar.date(byAdding: .year,
                                          value: -1,
                                          to: endDate)
            case .custom(let interval):
                return interval
            }
            return DateInterval(start: startDate ?? Date(), end: endDate)
        }
    }
}
