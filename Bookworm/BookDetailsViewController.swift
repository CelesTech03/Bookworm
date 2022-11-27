//
//  BookDetailsViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class BookDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var book: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let img = book?["imageLinks"] as? NSDictionary{
            let url = URL(string: img["thumbnail"] as! String)
            bookImage.downloaded(from: url!)
        }
        
        titleLabel.text = book["title"] as? String
        var author = ""
        if let authorArray = book?["authors"] as? NSArray{
            for i in authorArray {
                author += (i as? String)! + ", "
            }
        }
        authorsLabel.text = "By " + author
        
        //        pageCountLabel.text = book["pageCount"] as? String
        publishedDateLabel.text = book["publishedDate"] as? String
        publisherLabel.text = book["publisher"] as? String
        descriptionLabel.text = book["description"] as? String
    }
    
}
