//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation
protocol CoinManagerDelegate {
    func didUpdatePrice(price: String, currency: String)
    func didFailWithError(error: Error)
}

import Foundation

struct CoinManager {
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RUB","SEK","SGD","USD","ZAR"]

    var delegate: CoinManagerDelegate?

    func getCoinPrice(for currency: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=\(currency.lowercased())"

        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in

                if let error = error {
                    self.delegate?.didFailWithError(error: error)
                    return
                }

                if let safeData = data {
                    if let price = self.parseJSON(safeData, for: currency.lowercased()) {
                        let priceString = String(format: "%.2f", price)
                        self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }

    func parseJSON(_ data: Data, for currency: String) -> Double? {
        do {
            if let decoded = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let bitcoin = decoded["bitcoin"] as? [String: Any],
               let price = bitcoin[currency] as? Double {
                return price
            }
        } catch {
            delegate?.didFailWithError(error: error)
        }
        return nil
    }
}
