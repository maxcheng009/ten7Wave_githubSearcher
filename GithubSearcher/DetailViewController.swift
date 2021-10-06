import UIKit

class DetailViewController: UIViewController {

    
    //接收上一頁傳來的資料
    var passDate:String? //= nil
    var passHdurl:String? //= nil
    var passTitle:String? //= nil
    var passCopyright:String? //= nil
    var passDescription:String? //= nil
    
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var imgHdurl: UIImageView!
    @IBOutlet weak var txtTitle: UILabel!
    @IBOutlet weak var txtCopyright: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    
    weak var fristVC:UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        txtDate.text =  Date.getFormattedDate(dateString: passDate!, formatter: "yyyy MMM. d")
        imgHdurl.loadImageUsingCache(withUrl: passHdurl!)
        txtTitle.text = passTitle
        txtCopyright.text = passCopyright
        txtDescription.text = passDescription
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension Date {
    static func getFormattedDate(dateString: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = formatter
        
        let date: Date? = dateFormatterGet.date(from: dateString)
        print("Date",dateFormatterPrint.string(from: date!))
        return dateFormatterPrint.string(from: date!);
    }
}
