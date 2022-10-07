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
    
    private var rawData: [AssetMetrics] = []
    
    private var canUpdate: Bool = true
    
    private var task: Task = DataTask(dataTask: nil) {
        didSet {
            onTaskStateChanged(task.state)
        }
    }
}
//MARK: - Update
extension HomeViewModel {
    
    func update() {
        guard canUpdate else { return }
        task =
            CrypticAPI
            .Assets
            .all
            .decode(into: [AssetMetrics].self)
            .task { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let metrcis):
                    self.rawData = metrcis
                    self.parseRawData()
                case .failure(let error):
                    self.handle(error)
                }
            }
        task.resume()
    }
    
    private func parseRawData() {
        representedData = rawData.map { assetMetrics in
            let details = "\(assetMetrics.marketData.priceUSD)".prefix(6).description
            return HomeViewModelRepresentation(title: assetMetrics.symbol,
                                               subtitle: assetMetrics.name,
                                               details: details)
        }
    }
}
//MARK: - Search
extension HomeViewModel {
    
    func search(text: String) {
        
        guard !text.isEmpty else {
            representedData = cachedRepresentedData
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
        onError(.someDataLost(error))
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
    }
}
