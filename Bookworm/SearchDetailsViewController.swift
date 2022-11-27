//
//  SearchDetailsViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/21/22.
//

import UIKit

class SearchDetailsViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    // MARK: - Helper Methods
    func updateUI() {
        titleLabel.text = searchResult.title
        if searchResult.authors.isEmpty {
            authorsLabel.text = "Unknown"
        } else {
            authorsLabel.text = searchResult.authors.joined(separator: ", ")
        }
        if let smallURL = URL(string: searchResult.imageLinks.smallThumbnail) {
            downloadTask = bookImage.loadImage(url: smallURL)
        }
        publisherLabel.text = searchResult.publisher
        descriptionLabel.text = searchResult.description
        publishedDateLabel.text = searchResult.publishedDate
    }
    
}
