#  Cryptic API

Implementation of the API in a declarative style in the example of a crypto wallet app named Cryptic using Messari IO API.

## Features

    - Representation of back-end API methods in form of protocols, classes and, most importantly, enums; 
    - No more giant class-managers that are responsible for everything starting with request building and ending with error handling, only S-principle and DRY. Enums represent groups of API methods, and their cases represent methods themselves. One enum one group, simple as that;
    - Configuring request and its response handling step-by-step declaratively;
    - Wrapping and managing URL session tasks including their completion blocks;
    - Dealing with very specific server's responses by formatting any data using the JSON serialization.
    
## Using

```swift
    func update() {
        task =
            CrypticAPI
            .Assets
            .all
            .configure { request in
                request.config.parameters["fields"] = "metrics, symbol, name"
            }
            .decode(into: [AssetResponseItem].self)
            .task { [weak self] result in
                guard self = self else { return }
                self.handle(result)
            }
        observeTask()
        task.resume()
    }
```

## Backend API methods representation

Methods of the back-end API are represented in the form of protocols which allow to configure request.

```swift
protocol BackendMethod {
    var request: APIRequest { get }
    func task() -> Task
}

extension BackendMethod {
    func performCompletionBlock(on queue: DispatchQueue) -> BackendMethod {
        let oldRequest = request
        oldRequest.completionQueue = queue
        return self
    }
}

extension BackendMethod {
    func configure(_ updatingBlock: (APIRequest) -> ()) -> BackendMethod {
        updatingBlock(request)
        return self
    }
}

extension BackendMethod {
    
    func task(completion: @escaping (DataTaskResult<Data, APIError>) -> ()) -> Task {
        let requestWithCompletionBlock = self.request
        requestWithCompletionBlock.completion = completion
        return DataTask(request: requestWithCompletionBlock)
    }
}
```

Example of setting up a post-processing of the result.

```swift
protocol BackendMethodWithDecodedResult {
    
    associatedtype ResultType : Decodable
    
    func task(completion: @escaping (DataTaskResult<ResultType, APIError>) -> ()) -> Task
}

extension BackendMethod {

    func decode<T>(into: T.Type) -> DefaultBackendMethodWithDecodedResult<T> {
        return DefaultBackendMethodWithDecodedResult(from: self)
    }
}
```

Back-end API group and methods in form of enum and its cases.

```swift
protocol APIBackendMethod {
    
    var path: String { get }
    var parameters: [String : String] { get }

    func task(completion: @escaping (DataTaskResult<Data, APIError>) -> ()) -> Task
}

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
```

## P.S.

As you might've noticed, this is not a package or full-fledged project. It's just an example of an alternative way to build an API. By now, it may be a little raw at something, but it's going to be refined (hopefully).
