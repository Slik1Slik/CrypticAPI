//
//  HomeViewModelOutput.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

protocol HomeViewModelOutput {
    
    var onTaskStateChanged: (TaskState) -> () { get set }
    var onError: (HomeViewModelError) -> () { get set }
    
    var onSearchCompleted: () -> () { get set }
    
    var representedData: [HomeViewModelRepresentation] { get }
}
