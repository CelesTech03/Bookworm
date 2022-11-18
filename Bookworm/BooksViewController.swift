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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=stephen+king&key=AIzaSyBSXB3F8Z32lv8xH23G93_7-xUTIli4oLA&maxResults=30")!
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
    
    // MARK: - Table View Delegates
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "BookCell") as! BookCell
        
        let book = books[indexPath.row]["volumeInfo"] as? [String : Any]
        
        cell.titleLabel.text = book?["title"] as? String
        
        if let authorArray = book?["authors"] as? NSArray{
            cell.authorLabel.text = authorArray[0] as? String
        }
        
        cell.publisherLabel.text = book?["publisher"] as? String
        
        if let imgD = book?["imageLinks"] as? NSDictionary{
            let url = URL(string: imgD["thumbnail"] as! String)
            cell.bookImage.downloaded(from: url!)
        }
        
        return cell
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
