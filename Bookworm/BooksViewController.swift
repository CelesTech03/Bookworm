//
//  ViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/4/22.
//

import UIKit

class BooksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var books = [NSDictionary]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=programming")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.books = dataDictionary["items"] as! [NSDictionary]
                
                self.tableView.reloadData()
                // TODO: Get the array of books
                // TODO: Store the books in a property to use elsewhere
                // TODO: Reload the table view data
                
            }
        }
        task.resume()
    }
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell") as! BookCell
        
        let book = books[indexPath.row]["volumeInfo"] as! NSDictionary
        let title = book["title"] as? String
        cell.titleLabel.text = title
        cell.bookImage.image = UIImage(named: "alchemist.png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

