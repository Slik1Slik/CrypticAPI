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
    
    private var dataTask: URLSessionDataTask?
    
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
}

enum TaskState {
    case created
    case cancelled
    case inProgress
    case failed
    case finished
}
