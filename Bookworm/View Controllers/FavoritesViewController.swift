//
//  FavoritesViewController.swift
//  Bookworm
//
//  Created by Celeste Urena on 11/5/22.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var favTitleList:NSMutableArray = []
    var favAuthorList:NSMutableArray = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var darkSwitch: UISwitch!
    
    var managedObjectContext: NSManagedObjectContext!
    
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
        
        darkSwitch.isOn = UserDefaults.standard.bool(forKey: "darkAction")
        
    }
    
    // Reference: https://www.youtube.com/watch?v=0gQKlkV39M8
    @IBAction func toggleDark(_ sender: UISwitch) {

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let appDelegate = windowScene?.windows.first
        if darkSwitch.isOn == true {
            appDelegate?.overrideUserInterfaceStyle = .dark
        } else {
            appDelegate?.overrideUserInterfaceStyle = .light
        }
        UserDefaults.standard.set(darkSwitch.isOn, forKey: "darkAction")
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
