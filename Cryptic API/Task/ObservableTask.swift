//
//  ObservableTask.swift
//  Cryptic API
//
//  Created by Slik on 05.10.2022.
//

import Foundation

protocol ObservableTask : Task {
    
    func observe(onChanged: @escaping (TaskState) -> ())
}
