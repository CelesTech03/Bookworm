//
//  SearchResultCell.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/14/22.
//

import UIKit

class SearchResultCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var bookImageView: UIImageView!
    var downloadTask: URLSessionDownloadTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // Cancels any image download that is still in progress
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
    }
    
    // MARK: - Helper Methods
    func configure(for result: SearchResult) {
        titleLabel.text = result.title
        if result.authors.isEmpty {
            authorsLabel.text = "Unknown"
        } else {
            authorsLabel.text = String(format: "%@ (%@)", result.authors.joined(separator: ", "), result.publishedDate!)
        }
        bookImageView.image = UIImage(systemName: "square")
        if let smallURL = URL(string: result.imageLinks.smallThumbnail) {
            downloadTask = bookImageView.loadImage(url: smallURL)
        }
    }
    
}
