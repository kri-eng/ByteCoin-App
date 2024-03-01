//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateLabel(coinModel: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "B425FC66-7411-41F5-BEEA-C10974510327"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?
    
    //
    func getCoinPrice(for currency: String) {
        let finalURL = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(urlString: finalURL)
    }
    
    //
    func performRequest(urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: {(data, urlResponse, error) in
                // Handle the error
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                // Handle the data.
                if let safeData = data {
                    if let coinModel = parseJSON(data: safeData) {
                        self.delegate?.didUpdateLabel(coinModel: coinModel)
                    }
                }
            })
            task.resume()
        } else {
            print("Error: Did not generate a URL object!")
        }
    }
    
    func parseJSON(data: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let coinModel = CoinModel(rate: decodedData.rate, currency: decodedData.asset_id_quote)
            return coinModel
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
