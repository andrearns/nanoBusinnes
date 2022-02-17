import UIKit

final class HomeViewController: UIViewController {

    var record: Int = 0
    
    @IBOutlet var recordLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadRecord()
    }
    
    func reloadRecord() {
        record = UserDefaultsService.fetchRecord()
        self.recordLabel.text = "\(record)m"
    }
}
