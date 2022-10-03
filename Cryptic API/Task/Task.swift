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
    
    var state: TaskState
    
    private var dataTask: URLSessionDataTask? {
        didSet {
            updateTaskState()
        }
    }
    
    init(dataTask: URLSessionDataTask?) {
        self.dataTask = dataTask
        self.state = dataTask == nil ? .failed : .created
    }
    
    func cancel() {
        dataTask?.cancel()
    }
    
    func suspend() {
        dataTask?.suspend()
    }
    
    func resume() {
        dataTask?.resume()
    }
    
    private func updateTaskState() {
        guard let task = dataTask else {
            state = .finished
            return
        }
        switch task.state {
        case .running:
            state = .inProgress
        case .suspended:
            state = .suspended
        case .canceling:
            state = .cancelled
        case .completed:
            state = .finished
        @unknown default:
            state = .failed
        }
    }
}

enum TaskState {
    case created
    case cancelled
    case inProgress
    case suspended
    case failed
    case finished
}
