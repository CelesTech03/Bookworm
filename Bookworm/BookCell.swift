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
        
        // Changes the row selection color
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(named: "SearchBar")?.withAlphaComponent(0.5)
        selectedBackgroundView = selectedView
        
    }
    
    // Sets color of favorite button
    func setFavorite(_ isFavorited:Bool) {
        favorited = isFavorited
        if (favorited) {
            self.favButton.setImage(UIImage(named:"favor-icon-red"), for: UIControl.State.normal)
        }
        else {
            self.favButton.setImage(UIImage(named:"favor-icon"), for: UIControl.State.normal)
        }
    }
    
    // Sets state of fave button and adds a scale animation
    @IBAction func pulsePressed(_ sender: Any) {
        
        let toBeFavorited = !favorited
        if (toBeFavorited) {
            self.setFavorite(true)
        } else {
            self.setFavorite(false)
        }
        
        UIView.animate(withDuration: 0.2,
                       animations: { 
            self.favButton.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.favButton.transform = CGAffineTransform.identity
            }
        })

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
