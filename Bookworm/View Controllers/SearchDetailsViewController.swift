//
//  SearchDetailsViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/21/22.
//

import UIKit

class SearchDetailsViewController: UITableViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var publisherLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    
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
        // Sets labels with book data
        titleLabel.text = searchResult.title
        authorsLabel.text = "By " + (searchResult.authors?[0] ?? "No Author")
        if let smallURL = URL(string: (searchResult.imageLinks?.smallThumbnail ?? "No Image")) {
            downloadTask = bookImage.loadImage(url: smallURL)
        }
        publisherLabel.text = searchResult.publisher
        descriptionLabel.text = searchResult.description
        publishedDateLabel.text = searchResult.publishedDate
        categoriesLabel.text = searchResult.categories?[0]
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
