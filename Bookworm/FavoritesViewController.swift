//
//  FavoritesViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favTitleList:NSMutableArray = []
    var favAuthorList:NSMutableArray = []
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.object(forKey: "favTitle") != nil && UserDefaults.standard.object(forKey: "favAuthor") != nil {
            favTitleList = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "favTitle") as! NSArray)
            favAuthorList = NSMutableArray.init(array: UserDefaults.standard.object(forKey: "favAuthor") as! NSArray)
            
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    // MARK: - Table View Delegate
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favAuthorList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell") as! favCell
        
        cell.titleLabel.text = favTitleList.object(at: indexPath.row) as? String
        cell.authorLabel.text = favAuthorList.object(at: indexPath.row) as? String
        
        return cell
    }
    
}
