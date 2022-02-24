import UIKit
import StoreKit

final class HomeViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var record: Int = 0
    let removeAdsProductIdentifier = "com.andrearns.everestClimber.products.removeAds"
    var removeAdsProduct: SKProduct?
    
    @IBOutlet var recordLabel: UILabel!
    @IBOutlet var removeAdsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadRecord()
        fetchProducts()
    }
    
    func reloadRecord() {
        record = UserDefaultsService.fetchRecord()
        self.recordLabel.text = "\(record)m"
    }
    
    @IBAction func removeAds(_ sender: Any) {
        guard let removeAdsProduct = removeAdsProduct else {
            return
        }
        
        if SKPaymentQueue.canMakePayments() {
            let payment = SKPayment(product: removeAdsProduct)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
        }
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: [removeAdsProductIdentifier])
        request.delegate = self
        request.start()
    }
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            removeAdsProduct = product
            print("Product identifier:", product.productIdentifier)
            print("Product price:", product.price)
            print("Product title:", product.localizedTitle)
            print("Product description:", product.localizedDescription)
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchasing:
                // no op
                break
            case .purchased, .restored:
                // unlock their item
                removeAdsButton.alpha = 0
                UserDefaults.standard.set(true, forKey: "ads_removed")
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            case .failed, .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            default:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                break
            }
        }
    }
}
