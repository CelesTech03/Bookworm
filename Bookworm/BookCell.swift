//
//  BookCell.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class BookCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    var favorited:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func favoriteBook(_ sender: Any) {
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            self.setFavorite(true)
        } else {
            self.setFavorite(false)
        }
    }
    
    // Sets color of favorite icon
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
}
