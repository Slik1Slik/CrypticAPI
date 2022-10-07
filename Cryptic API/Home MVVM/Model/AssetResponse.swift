//
//  AssetResponse.swift
//  Cryptic API
//
//  Created by Slik on 04.10.2022.
//

import Foundation

struct AssetResponseItem : Decodable {
    var symbol: String = ""
    var name: String = ""
    var metrics: AssetMetrics
}
