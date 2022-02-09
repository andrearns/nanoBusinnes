import UIKit

final class HomeViewController: UIViewController {

    var record: Int = 0
    
    @IBOutlet var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadRecord()
    }
    
    @IBAction func removeAds(_ sender: Any) {
        print("Remove Ads")
    }
    
    func reloadRecord() {
        record = UserDefaultsService.fetchRecord()
        self.recordLabel.text = "\(record)m"
    }
}
