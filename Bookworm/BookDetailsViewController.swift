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
    @IBOutlet weak var pageCountLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var book: [String:Any]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if let imgD = book?["imageLinks"] as? NSDictionary{
            let url = URL(string: imgD["thumbnail"] as! String)
            bookImage.downloaded(from: url!)
        }
        titleLabel.text = book["title"] as? String
        authorsLabel.text = book["authors"] as? String
        pageCountLabel.text = book["pageCount"] as? String
        publishedDateLabel.text = book["publishedDate"] as? String
        publisherLabel.text = book["publisher"] as? String
        descriptionLabel.text = book["description"] as? String
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
