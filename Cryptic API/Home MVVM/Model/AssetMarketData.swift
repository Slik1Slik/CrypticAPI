//
//  AssetMarketData.swift
//  Cryptic API
//
//  Created by Slik on 02.10.2022.
//

import Foundation

struct AssetMarketData : Decodable {
    
    var priceUSD: Double = 0
    
    enum CodingKeys: String, CodingKey {
        case priceUSD = "price_usd"
    }
}
