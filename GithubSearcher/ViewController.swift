import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var txtSearchName: UITextField!
    let usDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    usDefaults.setValue(txtSearchName.text, forKey: "SearchName")
    }
}

