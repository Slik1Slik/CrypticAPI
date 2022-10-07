//
//  Task.swift
//  Cryptic API
//
//  Created by Slik on 29.09.2022.
//

import Foundation

protocol Task : AnyObject {
    
    func cancel()
    func suspend()
    func resume()
    
    var state: TaskState { get }
}

final class DataTask : Task {
    
    var state: TaskState = .none {
        didSet {
            onTaskStateChanged(state)
        }
    }
    
    private var dataTask: URLSessionDataTask?
    
    private var request: APIRequest
    
    private var onTaskStateChanged: (TaskState) -> () = { _ in }
    
    init(request: APIRequest) {
        self.request = request
    }
    
    func cancel() {
        dataTask?.cancel()
        state = .cancelled
    }
    
    func suspend() {
        dataTask?.suspend()
        state = .suspended
    }
    
    func resume() {
        if state != .suspended {
            setNewTask()
        }
        dataTask?.resume()
        state = .inProgress
    }
    
    private func setNewTask() {
        guard let urlRequest = try? APIURLRequestBuilder().build(from: request.config) else
        {
            request.completion(.failure(.failedToCreateURL))
            return
        }
        dataTask = createDataTask(from: urlRequest)
        state = .created
    }
    
    private func createDataTask(from urlRequest: URLRequest) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let self = self else { return }
            self.request.completionQueue.async {
                let handler = URLSessionDataTaskResultHandler(data: data,
                                                    response: response,
                                                    error: error)
                handler.handle { result in
                    switch result {
                    case .success(let data):
                        self.request.completion(.success(data))
                        self.state = .finished
                    case .failure(let error):
                        self.request.completion(.failure(error))
                        self.state = .failed
                    }
                }
            }
        }
    }
}

extension DataTask : ObservableTask {
    
    func observe(onChanged: @escaping (TaskState) -> ()) {
        onTaskStateChanged = onChanged
    }
}

enum TaskState {
    case none
    case created
    case cancelled
    case inProgress
    case suspended
    case failed
    case finished
}
