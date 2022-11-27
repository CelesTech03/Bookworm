//
//  ViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/4/22.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var books = [[String: Any]]()
    
    @IBOutlet weak var tableView: UITableView!
    
    var favListArray:NSMutableArray = []
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if UserDefaults.standard.object(forKey: "favList") != nil {
            
            favListArray = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "favList") as! NSArray)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=ios+programming&maxResults=40")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.books = dataDictionary["items"] as! [[String : Any]]
                
                self.tableView.reloadData()
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookCell") as! BookCell
        
        let book = books[indexPath.row]["volumeInfo"] as? [String : Any]
        
        cell.titleLabel.text = book?["title"] as? String
        
        var author = ""
        if let authorArray = book?["authors"] as? NSArray {
            for i in authorArray {
                author += (i as? String)! + ", "
            }
        }
        
        cell.authorLabel.text = "By " + author
        
        // Sets book image
        if let img = book?["imageLinks"] as? NSDictionary{
            let url = URL(string: img["thumbnail"] as! String)
            cell.bookImage.downloaded(from: url!)
        }
        
        // Changes like button color
        if favListArray.contains(cell.titleLabel.text!) {
            cell.favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
            
        } else {
            cell.favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
        
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(self, action:#selector(addToFav) , for: UIControl.Event.touchUpInside)
        
        return cell
    }
    
    @objc func addToFav(_ sender: UIButton) {
        
        let cell = self.tableView.cellForRow(at: NSIndexPath.init(row: sender.tag, section: 0) as IndexPath) as! BookCell
        
        if favListArray.contains(cell.titleLabel.text!) {
            favListArray.remove(cell.titleLabel.text!)
        } else {
            favListArray.add(cell.titleLabel.text!)
        }
        
        tableView.reloadData()
        UserDefaults.standard.set(favListArray, forKey: "favList")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Find selected book
        let cell = sender as! UITableViewCell
        
        let indexPath = tableView.indexPath(for: cell)!
        let book = books[indexPath.row]["volumeInfo"] as? [String:Any]
        
        // Pass selected book to the book details view controller
        let detailsViewController = segue.destination as! BookDetailsViewController
        detailsViewController.book = book
        
        // Deselects row once tapped
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
