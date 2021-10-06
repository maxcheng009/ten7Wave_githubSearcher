import UIKit
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


class MenuViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegate {
    
    @IBOutlet weak var btnPrev: UIBarButtonItem!
    @IBOutlet weak var btnNext: UIBarButtonItem!
    var page = 1
    var per_page = 28
    var totolpage = 0
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @IBAction func clickBtnPrev(_ sender: Any) {
        if page > 1
        {
        page -= 1
        getData()
        }
    }
    
    @IBAction func clickBtnNext(_ sender: Any) {
        if page < totolpage
        {
        page += 1
        getData()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if aqiArray != nil {
            return self.aqiArray!.count
        }else{
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       if aqiArray != nil {
            let cell = aqiCollectionView.dequeueReusableCell(withReuseIdentifier: "aqiCell", for: indexPath) as! AqiCollectionViewCell
        cell.txtTitle.text = aqiArray![indexPath.row].login!
           //
        cell.imgView.loadImageUsingCache(withUrl: aqiArray![indexPath.row].avatarUrl!)
           
        return cell
       }else{
        let errorCell = aqiCollectionView.dequeueReusableCell(withReuseIdentifier: "errorCell", for: indexPath)
        return errorCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        selectedRow = indexPath.row
//        if aqiArray != nil {
//            self.performSegue(withIdentifier: "userSelectSegue", sender: self)
//        }
    }
    
    @IBOutlet weak var aqiCollectionView: UICollectionView!
    var selectedRow = 0
//    var timer: Timer!
    var refreshControl: UIRefreshControl!
    var aqiArray :[ten7waveItem]?
    
    //set 4 rows flowlayout
    let columnLayout = ColumnFlowLayout(
        cellsPerRow: 4,
        minimumInteritemSpacing: 1,
        minimumLineSpacing: 1,
        sectionInset: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
    )
    
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - fetch data in the first time
        if aqiArray == nil{
        getData()
        aqiCollectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //set delgates
        aqiCollectionView.dataSource = self
        aqiCollectionView.delegate = self
        //set 4 rows
        aqiCollectionView?.collectionViewLayout = columnLayout
        aqiCollectionView?.contentInsetAdjustmentBehavior = .always
        //refresh
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(updateData), for: UIControl.Event.valueChanged)
        aqiCollectionView.addSubview(refreshControl)
        
        //MARK: - fetch data in the first time
        getData()
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
	
   
        if (segue.identifier == "userSelectSegue") {
            let nextVC =  segue.destination as! DetailViewController
//            nextVC.passDate = self.aqiArray?[selectedRow].date
            nextVC.passHdurl = self.aqiArray?[selectedRow].avatarUrl
//            nextVC.passTitle = self.aqiArray?[selectedRow].title
            nextVC.passDescription = self.aqiArray?[selectedRow].login
        }
        
    }
 

    // refresh
    @objc func updateData() {
        DispatchQueue.main.async {
            self.getData()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
                self.refreshControl.endRefreshing()
            }
        }
    }
}


extension MenuViewController{
    func getData() {
        let usDefaults = UserDefaults()

        let semaphore = DispatchSemaphore (value: 0)
    
        let searchName = usDefaults.value(forKey: "SearchName") as! String
        
        var request = URLRequest(url: URL(string: "https://api.github.com/search/users?q=\(searchName)&per_page=\(per_page)&page=\(page)")!,timeoutInterval: Double.infinity)
        request.addValue("'Mozilla/5.0',", forHTTPHeaderField: "'User-Agent'")
        request.addValue("'token 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',", forHTTPHeaderField: "'Authorization'")
        request.addValue("'application/json',", forHTTPHeaderField: "'Content-Type'")
        request.addValue("'GET',", forHTTPHeaderField: "'method'")
        request.addValue("'application/json'", forHTTPHeaderField: "'Accept'")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            
            if let data = data {
                        do {
                            let totalDicArray = try JSONDecoder().decode(ten7waveGitHub.self, from: data)

                            self.aqiArray = totalDicArray.items
                            
                            DispatchQueue.main.async {
                                                  //最後再重新讀取 tabelView 的資料一次
                                                  self.aqiCollectionView.reloadData()
                                              }
                                
                            if let totalCount = totalDicArray.totalCount {
                                print("totlalCount:",totalCount)
                                self.totolpage = Int(totalCount / self.per_page) + 1
                                print("totlpage:",self.totolpage)
                            }

                        } catch  {
                            print(error)
                        }
                
                    }
    
          
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
//          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        self.title = "\(page)/\(totolpage)"
        }
    }


let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        if url == nil {return}
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = true // default is true
        // Springs and struts
        activityIndicator.center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        activityIndicator.autoresizingMask = [
            .flexibleLeftMargin,
            .flexibleRightMargin,
            .flexibleTopMargin,
            .flexibleBottomMargin
        ]
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                    activityIndicator.removeFromSuperview()
                }
            }
            
        }).resume()
    }
}

