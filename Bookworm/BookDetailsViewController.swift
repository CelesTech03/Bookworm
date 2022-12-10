//
//  BookDetailsViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class BookDetailsViewController: UITableViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    var book: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let img = book?["imageLinks"] as? NSDictionary {
            let url = URL(string: img["thumbnail"] as! String)
            bookImage.downloaded(from: url!)
        }
        
        titleLabel.text = book["title"] as? String
        if let authorArray = book?["authors"] as? NSArray {
            let author = authorArray[0] as? String
            authorsLabel.text = "By " + (author ?? "No author")
        }
        
        publishedDateLabel.text = book["publishedDate"] as? String
        publisherLabel.text = book["publisher"] as? String
        descriptionLabel.text = book["description"] as? String
        if let categoriesArray = book?["categories"] as? NSArray {
            let category = categoriesArray[0] as? String
            categoryLabel.text = category
        }
    }
    
    // MARK: - Table View Delegate
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // Allows static cell resizing
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
