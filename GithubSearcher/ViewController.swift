import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var txtSearchName: UITextField!
    let usDefaults = UserDefaults()
    override func viewDidLoad() {
        super.viewDidLoad()
        btnOK.isEnabled = false
    }
    
    @IBOutlet weak var btnOK: UIButton!
    
    @IBAction func changeSearchText(_ sender: Any) {
        if txtSearchName.text != ""
        {
            btnOK.isEnabled = true
        }else{
            btnOK.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    usDefaults.setValue(txtSearchName.text, forKey: "SearchName")
    }
}

