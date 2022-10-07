//
//  HomeViewModel.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

protocol HomeViewModelProtocol : HomeViewModelInput, HomeViewModelOutput { }

final class HomeViewModel : HomeViewModelProtocol {
    
    var onTaskStateChanged: (TaskState) -> () = { _ in }
    
    var onError: (HomeViewModelError) -> () = { _ in }
    
    var onSearchCompleted: () -> () = { }
    
    var representedData: [HomeViewModelRepresentation] = []
    private var cachedRepresentedData: [HomeViewModelRepresentation] = []
    
    private var rawData: [AssetResponseItem] = []
    
    private var canUpdate: Bool = NetworkService.shared.isConnectionAvailable
    
    private var task: Task = DataTask(request: .init())
}
//MARK: - Update
extension HomeViewModel {
    
    func update() {
        
        // Lines below are commented out, as there's a bug in the last emulator version
        // which makes NWPathMonitor instance set its current path status to unsatisfied
        // when the connection is actually available.
        // When it is not, the property, on the contrary, is set to satisfied.
        // Once it's solved, I fix this
        
//        guard canUpdate else {
//            onError(.noInternetConnection)
//            return
//        }
        task =
            CrypticAPI
            .Assets
            .all
            .configure { request in
                request.config.parameters["fields"] = "metrics, symbol, name"
            }
            .decode(into: [AssetResponseItem].self)
            .task { [weak self] result in
                self?.handle(result)
            }
        observeTask()
        task.resume()
    }
    
    private func handle(_ dataTaskResult: DataTaskResult<[AssetResponseItem], APIError>) {
        switch dataTaskResult {
        case .success(let response):
            rawData = response
            parseRawData()
            cachedRepresentedData = representedData
        case .failure(let error):
            handle(error)
        }
    }
    
    private func parseRawData() {
        representedData = rawData.map { response in
            let priceUSD = response.metrics.marketData.priceUSD
            let details = "\(Double(round(10000 * priceUSD) / 10000))"
            return HomeViewModelRepresentation(title: response.symbol,
                                               subtitle: response.name,
                                               details: details)
        }
    }
    
    private func observeTask() {
        (task as? ObservableTask)?.observe(onChanged: onTaskStateChanged)
    }
}
//MARK: - Search
extension HomeViewModel {
    
    func search(text: String) {
        
        guard !text.isEmpty else {
            representedData = cachedRepresentedData
            onSearchCompleted()
            return
        }
        
        representedData = cachedRepresentedData.filter { data in
            data.title.contains(text.uppercased())
        }
        
        onSearchCompleted()
    }
    
}
//MARK: - Select
extension HomeViewModel {
    
    func select(atIndex index: Int) {
        //TODO: Asset details MVVM-module pushing
    }
}
//MARK: - Error handling
extension HomeViewModel {
    
    func handle(_ error: APIError) {
        switch error {
        case .noConnection:
            onError(.noInternetConnection)
        default:
            onError(.someDataLost(error))
        }
    }
}
//MARK: - Network
extension HomeViewModel {
    
    private func observeInternetConnectionChanges() {
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onInternetConnectionLost),
                                               name: NetworkService.Notifications.internetConnectionDidBecomeLostNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onInternetConnectionDidRestore),
                                               name: NetworkService.Notifications.internetConnectionDidRestoreNotification,
                                               object: nil)
    }
    
    @objc private func onInternetConnectionLost() {
        canUpdate = false
        if task.state == .inProgress {
            task.cancel()
        }
        onError(.noInternetConnection)
    }
    
    @objc private func onInternetConnectionDidRestore() {
        canUpdate = true
        update()
    }
}
