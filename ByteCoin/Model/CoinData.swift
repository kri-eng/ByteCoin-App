//
//  CoinData.swift
//  ByteCoin
//
//  Created by Krish Patel on 2/19/24.
//  Copyright © 2024 The App Brewery. All rights reserved.
//

import Foundation

struct CoinData: Codable {
    let asset_id_base: String
    let asset_id_quote: String
    let rate: Float
}
