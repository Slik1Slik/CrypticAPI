//
//  AssetMetrcis.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

struct AssetMetrics : Decodable {
    
    var marketData: AssetMarketData = .init()
    
    enum CodingKeys: String, CodingKey {
        case marketData = "market_data"
    }
}
