//
//  ViewController.swift
//  ByteCoin
//
//

import UIKit
// 1- Protocol added UIPickerViewDataSource
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // to determine how many columns we want in our picker.
        return 1
    }
    var coinManager = CoinManager()
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    var fetchTimer: Timer?

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        fetchTimer?.invalidate() // Cancel previous timer
        let selectedCurrency = coinManager.currencyArray[row]

        // Delay the API call slightly to avoid spamming on fast scrolls
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.coinManager.getCoinPrice(for: selectedCurrency)
        }
    }
    
    func didUpdatePrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitcoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(error: Error) {
        print(" Error: \(error.localizedDescription)")
    }
    
    
    
    @IBOutlet weak var bitcoinLabel: UILabel!
    
    @IBOutlet weak var currencyLabel: UILabel!
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        coinManager.delegate = self
    }
    
    
}

